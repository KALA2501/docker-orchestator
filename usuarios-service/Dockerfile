# Stage 1: Build
FROM maven:3.9.4-eclipse-temurin-21 AS build
WORKDIR /app

# Clone the project
RUN git clone --single-branch --branch main https://github.com/KALA2501/MicroservicioUsuarios.git

# Move into the actual project directory
WORKDIR /app/MicroservicioUsuarios

# Build the jar
RUN mvn clean package -DskipTests

# Stage 2: Run
FROM eclipse-temurin:21-jdk-jammy
WORKDIR /app

# Copiar el jar
COPY --from=build /app/MicroservicioUsuarios/target/*.jar app.jar

# Copiar el entrypoint
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Exponer el puerto
EXPOSE 9091

# Usar el entrypoint personalizado
ENTRYPOINT ["/app/entrypoint.sh"]
