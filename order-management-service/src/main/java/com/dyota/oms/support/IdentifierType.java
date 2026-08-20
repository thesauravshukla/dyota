package com.dyota.oms.support;

/**
 * Mirrors authentication-service's enum. Deliberately duplicated rather than shared:
 * a shared library would couple the two services' release cycles for four lines.
 */
public enum IdentifierType {
    EMAIL,
    PHONE
}
