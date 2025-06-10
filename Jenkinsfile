pipeline {
    agent any

    environment {
        // Define a unique name for our Docker image
        DOCKER_IMAGE_NAME = "java-cicd-demo-app"
        DOCKER_IMAGE_TAG = "latest"
    }

    stages {
        stage('Checkout') {
            steps {
                // Get the source code from Git
                echo 'Checking out code...'
                checkout scm
            }
        }

        stage('Build Application') {
            steps {
                // Build the Java application using Maven
                echo 'Building the application with Maven...'
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                // Build a new Docker image
                echo "Building Docker image: ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
                script {
                    def dockerImage = docker.build("${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}")
                }
            }
        }

        stage('Deploy Application') {
            steps {
                // Deploy the new Docker container
                echo "Deploying the container..."
                script {
                    // Stop and remove the old container if it exists, to avoid port conflicts
                    // The '|| true' ensures the command doesn't fail if the container isn't running
                    sh "docker stop ${DOCKER_IMAGE_NAME} || true"
                    sh "docker rm ${DOCKER_IMAGE_NAME} || true"

                    // Run the new container
                    docker.image("${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}").run("-d -p 8081:8081 --name ${DOCKER_IMAGE_NAME}")
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
            // Optional: Clean up old Docker images to save space
            // sh 'docker image prune -f'
        }
    }
}
