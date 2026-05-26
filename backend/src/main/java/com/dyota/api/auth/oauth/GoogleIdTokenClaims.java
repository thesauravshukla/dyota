package com.dyota.api.auth.oauth;

public record GoogleIdTokenClaims(String subject, String email, boolean emailVerified) {}
