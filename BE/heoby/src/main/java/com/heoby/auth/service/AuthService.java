package com.heoby.auth.service;

import com.heoby.auth.dto.request.LoginRequest;
import com.heoby.auth.dto.request.RefreshRequest;
import com.heoby.auth.dto.request.SignupRequest;
import com.heoby.auth.dto.response.LoginResponse;
import com.heoby.auth.dto.response.TokenResponse;

public interface AuthService {
    void signup(SignupRequest request);
    LoginResponse login(LoginRequest request);
    TokenResponse refresh(RefreshRequest request);
    void logout(String accessToken, RefreshRequest request);

}
