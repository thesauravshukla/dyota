package com.dyota.api.auth.service;

import com.dyota.api.auth.domain.User;

public record AuthResult(String accessToken, String refreshToken, long expiresInSeconds, User user) {}
