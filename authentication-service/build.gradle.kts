plugins {
    java
    id("org.springframework.boot") version "3.3.4"
    id("io.spring.dependency-management") version "1.1.6"
}

group = "com.dyota"
version = "0.1.0-SNAPSHOT"

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(21)
    }
}

repositories {
    mavenCentral()
}

dependencies {
    implementation("org.springframework.boot:spring-boot-starter-web")
    implementation("org.springframework.boot:spring-boot-starter-data-jpa")
    implementation("org.springframework.boot:spring-boot-starter-validation")
    implementation("org.springframework.boot:spring-boot-starter-mail")
    implementation("org.springframework.boot:spring-boot-starter-actuator")

    runtimeOnly("org.postgresql:postgresql")
    implementation("org.flywaydb:flyway-core")
    implementation("org.flywaydb:flyway-database-postgresql")

    annotationProcessor("org.springframework.boot:spring-boot-configuration-processor")

    testImplementation("org.springframework.boot:spring-boot-starter-test")
    testImplementation("org.testcontainers:junit-jupiter:1.21.4")
    testImplementation("org.testcontainers:postgresql:1.21.4")
}

tasks.withType<Test> {
    useJUnitPlatform()

    // Docker Desktop on macOS puts its socket under the user's home and exposes it
    // through a docker context rather than /var/run/docker.sock. Testcontainers does
    // not always resolve that context, so point it at the socket when one is there and
    // the environment has not already said otherwise.
    if (System.getenv("DOCKER_HOST") == null) {
        val socket = File(System.getProperty("user.home"), ".docker/run/docker.sock")
        if (socket.exists()) {
            environment("DOCKER_HOST", "unix://${socket.absolutePath}")
        }
    }

    // docker-java defaults to Docker API 1.32, which Docker Engine 25+ rejects outright
    // (it requires 1.40 or newer) with an opaque HTTP 400. Pin a version both ends
    // support. Override with DOCKER_API_VERSION if you are on an older daemon.
    systemProperty("api.version", System.getenv("DOCKER_API_VERSION") ?: "1.44")
}

