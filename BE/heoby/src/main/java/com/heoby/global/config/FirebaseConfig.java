package com.heoby.global.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

@Configuration
public class FirebaseConfig {

  @Value("${GOOGLE_APPLICATION_CREDENTIALS:}")
  private String googleCredPath;

  private final org.springframework.core.io.ResourceLoader loader;

  public FirebaseConfig(org.springframework.core.io.ResourceLoader loader) {
    this.loader = loader;
  }

  @PostConstruct
  public void init() throws Exception {
    // 이전 인스턴스 제거(캐시 청소)
    if (!FirebaseApp.getApps().isEmpty()) {
      FirebaseApp.getApps().forEach(FirebaseApp::delete);
      System.out.println("♻️ FirebaseApp cleared");
    }

    if (!org.springframework.util.StringUtils.hasText(googleCredPath)) {
      throw new IllegalStateException(
          "GOOGLE_APPLICATION_CREDENTIALS is empty. Set it in .env or OS env to the *correct* key path.");
    }

    // classpath:/file: 모두 지원
    String loc = (googleCredPath.startsWith("classpath:") || googleCredPath.startsWith("file:"))
        ? googleCredPath : "file:" + googleCredPath;

    var res = loader.getResource(loc);
    if (!res.exists()) {
      throw new java.io.FileNotFoundException("Firebase key not found at: " + loc);
    }

    var scopes = java.util.List.of("https://www.googleapis.com/auth/firebase.messaging");
    try (var in = res.getInputStream()) {
      var creds = GoogleCredentials.fromStream(in).createScoped(scopes);
      var options = FirebaseOptions.builder().setCredentials(creds).build();
      FirebaseApp.initializeApp(options);
      System.out.println("✅ Firebase initialized with: " + loc);
    }
  }
}
