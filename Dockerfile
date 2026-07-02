# Usar una imagen base de Java 21, que es la que requiere el proyecto
FROM openjdk:21-jdk-slim

# Argumento para la ruta del archivo JAR que genera Spring Boot
ARG JAR_FILE=target/*.jar

# Copiar el archivo JAR al contenedor y renombrarlo a app.jar
COPY ${JAR_FILE} app.jar

# Exponer el puerto 8080, que es el puerto por defecto de Spring Boot
EXPOSE 8080

# Comando para ejecutar la aplicación cuando el contenedor se inicie
ENTRYPOINT ["java","-jar","/app.jar"]
