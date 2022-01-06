FROM openjdk:11-jre-slim

ENV APP_PORT=8083

COPY bank-microservice/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]