# ============================================================
#  Dockerfile del backend (Spring Boot + Gradle con Kotlin DSL)
#  Va en la RAÍZ del repositorio, al lado del build.gradle.kts
#  Si tu proyecto usa Java 21, cambia 17 por 21 en las dos líneas FROM.
#
#  Dos etapas:
#   1. "build": una imagen con el JDK compila el .jar con ./gradlew
#   2. final:   una imagen chica, solo con Java (JRE) y el .jar
# ============================================================

# ---------- Etapa 1: compilar ----------
FROM eclipse-temurin:21-jdk AS build
WORKDIR /app

# Primero solo lo que define las dependencias: si no cambia,
# Docker reutiliza esta capa y no vuelve a descargar librerías.
COPY gradlew settings.gradle build.gradle ./
COPY gradle ./gradle
# Si el proyecto se creó en Windows, gradlew puede traer saltos de línea de Windows
RUN sed -i 's/\r$//' gradlew && chmod +x gradlew
RUN ./gradlew dependencies --no-daemon > /dev/null

# Después el código fuente
COPY src ./src
RUN ./gradlew bootJar -x test --no-daemon

# ---------- Etapa 2: ejecutar ----------
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Un usuario sin privilegios de administrador (número 10001)
RUN addgroup -S -g 10001 app && adduser -S -u 10001 -G app app

COPY --from=build /app/build/libs/*.jar app.jar
USER 10001

EXPOSE 8080

# La JVM usa hasta el 75% de la memoria que le dé el contenedor
ENTRYPOINT ["java", "-XX:MaxRAMPercentage=75", "-jar", "app.jar"]
