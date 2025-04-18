# Etapa 1: Build
FROM maven:3.9.4-eclipse-temurin-21 AS build

WORKDIR /app

# Clone the repository from GitHub
RUN git clone https://github.com/KALA2501/ConfigServer .

# Fetch dependencies and build the project
RUN mvn dependency:go-offline
RUN mvn clean package -DskipTests

# Etapa 2: Run
FROM eclipse-temurin:21-jdk-jammy

WORKDIR /app

# Copy the .jar generated from the previous stage
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8888

ENTRYPOINT ["java", "-jar", "app.jar"]
