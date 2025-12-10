package com.heoby.fcm.service;


import java.util.List;
import java.util.Map;

public interface FcmPushService {

  void sendToToken(String token, String title, String body, Map<String, String> data);
  void sendToTokens(List<String> tokens, String title, String body, Map<String, String> data);

  SendResult sendToTokensWithResult(List<String> tokens, String title, String body, Map<String, String> data);
  record SendResult(int requested, int success, int failure, int disabled, int retried) {}
}
