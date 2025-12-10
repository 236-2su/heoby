# syntax=docker/dockerfile:1

FROM gradle:8.10.2-jdk17-alpine AS builder
WORKDIR /workspace
COPY BE/heoby/ ./
RUN chmod +x gradlew && ./gradlew bootJar --no-daemon

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=builder /workspace/build/libs/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","/app/app.jar"]
