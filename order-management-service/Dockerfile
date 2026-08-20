# syntax=docker/dockerfile:1

# Build stage. The gradle cache is mounted rather than copied so rebuilds do not
# re-download the whole dependency tree on every source change.
FROM eclipse-temurin:21-jdk-alpine AS build
WORKDIR /workspace
COPY gradlew settings.gradle.kts build.gradle.kts gradle.properties ./
COPY gradle gradle
RUN chmod +x gradlew
COPY src src
RUN --mount=type=cache,target=/root/.gradle ./gradlew --no-daemon bootJar -x test

# Runtime stage: JRE only, and not running as root.
FROM eclipse-temurin:21-jre-alpine
RUN addgroup -S app && adduser -S app -G app
WORKDIR /app
COPY --from=build /workspace/build/libs/*.jar app.jar
USER app
ENTRYPOINT ["java", "-XX:MaxRAMPercentage=75", "-jar", "/app/app.jar"]
