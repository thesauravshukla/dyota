package com.dyota.oms.user.domain;

public enum UserStatus {
    ACTIVE,
    SUSPENDED,
    DELETED;

    public boolean canLogIn() {
        return this == ACTIVE;
    }
}
