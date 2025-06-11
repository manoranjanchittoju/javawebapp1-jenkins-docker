pipeline {
    agent {
        docker {
            image 'maven:3.8.7-eclipse-temurin-17'
            args '-v /root/.m2:/root/.m2'
        }
    }

    environment {
        // Docker registry info if needed
        REGISTRY = 'your-docker-registry.example.com'
        IMAGE_NAME = 'your-app-name'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Test') {
            steps {
                // Publish JUnit test results (adjust path if your reports are elsewhere)
                junit 'target/surefire-reports/*.xml'
            }
        }

        stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar, target/*.war', fingerprint: true
            }
        }

        stage('Build & Push Docker Image') {
            when {
                expression { env.BUILD_DOCKER == 'true' }
            }
            steps {
                script {
                    docker.withRegistry("https://${env.REGISTRY}", 'docker-credentials-id') {
                        def appImage = docker.build("${env.REGISTRY}/${env.IMAGE_NAME}:${env.IMAGE_TAG}")
                        appImage.push()
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Build #${env.BUILD_NUMBER} completed successfully!"
        }
        failure {
            echo "Build failed. Please check the logs."
        }
    }
}
