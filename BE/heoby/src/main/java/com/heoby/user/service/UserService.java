package com.heoby.user.service;

import com.heoby.user.dto.request.UserDeleteRequest;
import com.heoby.user.dto.response.UserResponse;

public interface UserService {

    UserResponse getMe(String userUuid);
    void updateUser(String userUuid, com.heoby.user.dto.request.UserUpdateRequest req);
    void deleteUser(String userUuid, String accessToken, UserDeleteRequest req);
}
