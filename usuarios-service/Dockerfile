FROM maven:3.9.4-eclipse-temurin-21

# Directorio de trabajo
WORKDIR /app

# Clona el repositorio directamente
RUN git clone --single-branch --branch main https://github.com/KALA2501/MicroservicioUsuarios.git

# Entra a la carpeta del microservicio
WORKDIR /app/MicroservicioUsuarios

# Expone el puerto del microservicio
EXPOSE 9091

# Ejecuta el microservicio usando Maven directamente
CMD ["mvn", "spring-boot:run"]
