# 1. Этап сборки (Gradle)
FROM gradle:8.12-jdk21 AS build
WORKDIR /app

# 2. Копируем файлы проекта и запускаем сборку
COPY --chown=gradle:gradle build.gradle settings.gradle gradlew ./
COPY --chown=gradle:gradle gradle/ ./gradle
COPY --chown=gradle:gradle src/ ./src
RUN chmod +x gradlew && ./gradlew build -x test

# 3. Этап выполнения (JDK + JAR)
FROM eclipse-temurin:21-jdk-alpine
WORKDIR /app

# 4. Копируем собранный JAR из предыдущего этапа
COPY --from=build /app/build/libs/*.jar app.jar

# 5. Запускаем приложение
ENTRYPOINT ["java", "-jar", "app.jar"]