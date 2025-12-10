package com.heoby.fcm.service;

import com.google.firebase.messaging.*;
import com.heoby.fcm.repository.DeviceTokenRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class FcmPushServiceImpl implements FcmPushService {

  private final DeviceTokenRepository deviceTokenRepository;

  @Override
  public void sendToToken(String token, String title, String body, Map<String, String> data) {
    if (token == null || token.isBlank()) {
      log.warn("⚠️ FCM: empty token, skip.");
      return;
    }

    String notiTitle = (title != null && !title.isBlank()) ? title : "Heoby 알림";
    String notiBody  = (body != null && !body.isBlank()) ? body : "";

    Map<String, String> payload = sanitize(data);

    Message msg = Message.builder()
        .setToken(token)
        .setNotification(
            Notification.builder()
                .setTitle(notiTitle)
                .setBody(notiBody)
                .build()
        )
        .putAllData(payload)
        .setAndroidConfig(buildAndroid())
        .setApnsConfig(buildApns())
        .build();

    try {
      String id = FirebaseMessaging.getInstance().send(msg);
      deviceTokenRepository.touchLastSeen(token, LocalDateTime.now());
      log.info("✅ FCM single sent: id={}", id);
    } catch (FirebaseMessagingException e) {
      handleSingleFailure(token, e);
    }
  }

  @Override
  public void sendToTokens(List<String> tokens, String title, String body, Map<String, String> data) {
    sendToTokensWithResult(tokens, title, body, data);
  }

  @Override
  public SendResult sendToTokensWithResult(List<String> tokens, String title, String body,
      Map<String, String> data) {
    if (tokens == null || tokens.isEmpty()) {
      log.warn("⚠️ FCM: empty token list, skip.");
      return new SendResult(0, 0, 0, 0, 0);
    }

    List<String> distinct = tokens.stream()
        .filter(t -> t != null && !t.isBlank())
        .distinct()
        .toList();

    String notiTitle = (title != null && !title.isBlank()) ? title : "Heoby 알림";
    String notiBody  = (body != null && !body.isBlank()) ? body : "";

    Map<String, String> payload = sanitize(data);

    int requested = distinct.size();
    int success = 0, failure = 0, disabled = 0, retriedTotal = 0;

    for (int i = 0; i < distinct.size(); i += 500) {
      List<String> batch = distinct.subList(i, Math.min(i + 500, distinct.size()));

      MulticastMessage msg = MulticastMessage.builder()
          .addAllTokens(batch)
          .setNotification(
              Notification.builder()
                  .setTitle(notiTitle)
                  .setBody(notiBody)
                  .build()
          )
          .putAllData(payload)
          .setAndroidConfig(buildAndroid())
          .setApnsConfig(buildApns())
          .build();

      var r = sendBatchWithRetry(msg, batch, 2);
      success      += r.success;
      failure      += r.failure;
      disabled     += r.disabled;
      retriedTotal += r.retried;
    }

    log.info("✅ FCM multi result: requested={} success={} failure={} disabled={} retried={}",
        requested, success, failure, disabled, retriedTotal);

    return new SendResult(requested, success, failure, disabled, retriedTotal);
  }

  private static Map<String, String> sanitize(Map<String, String> data) {
    if (data == null) return Map.of();
    return data.entrySet().stream()
        .filter(e -> e.getKey() != null && e.getValue() != null)
        .collect(Collectors.toUnmodifiableMap(Map.Entry::getKey, Map.Entry::getValue));
  }

  private AndroidConfig buildAndroid() {
    return AndroidConfig.builder()
        .setPriority(AndroidConfig.Priority.HIGH)
        .setTtl(3_600_000)
        .build();
  }

  private ApnsConfig buildApns() {
    return ApnsConfig.builder()
        .putHeader("apns-push-type", "alert")
        .putHeader("apns-priority", "10")
        .setAps(Aps.builder()
            .setContentAvailable(true)
            .build())
        .build();
  }

  private void handleSingleFailure(String token, FirebaseMessagingException e) {
    var code = e.getMessagingErrorCode();
    if (code == MessagingErrorCode.UNREGISTERED || code == MessagingErrorCode.INVALID_ARGUMENT) {
      deviceTokenRepository.disableByToken(token);
      log.warn("🧹 Disabled invalid token: {}", token);
    } else {
      log.error("❌ FCM send error: code={} msg={}", code, e.getMessage(), e);
    }
  }

  private BatchOutcome sendBatchWithRetry(MulticastMessage msg,
      List<String> batchTokens,
      int maxRetries) {
    int attempt = 0;
    long base = 300L;
    int success = 0, failure = 0, disabled = 0, retried = 0;

    while (true) {
      try {
        BatchResponse res = FirebaseMessaging.getInstance().sendEachForMulticast(msg);
        var responses = res.getResponses();
        int transientErr = 0;

        for (int i = 0; i < responses.size(); i++) {
          String token = batchTokens.get(i);
          SendResponse r = responses.get(i);

          if (r.isSuccessful()) {
            success++;
            deviceTokenRepository.touchLastSeen(token, LocalDateTime.now());
          } else {
            failure++;
            FirebaseMessagingException ex = r.getException();
            MessagingErrorCode code = ex != null ? ex.getMessagingErrorCode() : null;

            if (code == MessagingErrorCode.UNREGISTERED || code == MessagingErrorCode.INVALID_ARGUMENT) {
              deviceTokenRepository.disableByToken(token);
              disabled++;
            } else if (code == MessagingErrorCode.UNAVAILABLE || code == MessagingErrorCode.INTERNAL) {
              transientErr++;
            } else {
              log.warn("⚠️ FCM token={} failure code={} msg={}", token, code,
                  ex != null ? ex.getMessage() : "n/a");
            }
          }
        }

        if (transientErr > 0 && attempt < maxRetries) {
          attempt++;
          retried++;
          try { Thread.sleep((long) Math.pow(2, attempt) * base); } catch (InterruptedException ignored) {}
          continue;
        }

        return new BatchOutcome(success, failure, disabled, retried);

      } catch (FirebaseMessagingException e) {
        if (attempt++ < maxRetries) {
          retried++;
          try { Thread.sleep((long) Math.pow(2, attempt) * base); } catch (InterruptedException ignored) {}
          continue;
        }
        log.error("❌ FCM batch fatal after retries: {}", e.getMessage(), e);
        return new BatchOutcome(success, failure, disabled, retried);
      }
    }
  }

  private record BatchOutcome(int success, int failure, int disabled, int retried) {}
}
