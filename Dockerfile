# Start with a base image containing Java 17 runtime
FROM openjdk:17-jdk-slim

# The application's JAR file
ARG JAR_FILE=target/*.jar

# Copy the JAR file into the container at /opt/app.jar
COPY ${JAR_FILE} /opt/app.jar

# Tell Docker that the container listens on port 8081
EXPOSE 8081

# Run the JAR file
ENTRYPOINT ["java", "-jar", "/opt/app.jar"]
