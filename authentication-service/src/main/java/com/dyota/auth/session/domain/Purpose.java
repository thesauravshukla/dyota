package com.dyota.auth.session.domain;

/** Why the verification was started. Extensible without a schema change. */
public enum Purpose {
    LOGIN,
    SIGNUP
}
