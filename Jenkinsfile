pipeline {
    agent any

    parameters {
        base64File(description: "Upload the VPN .ovpn file", name: "OVPN_FILE")
        base64File(description: "Upload the auth.txt file", name: "AUTH_FILE")
    }

    environment {
        DOCKER_HUB_USERNAME = 'safii'
        DOCKER_HUB_PASSWORD = 'Bc8q3pzt!'
        DOCKER_HUB_REPOSITORY = 'docker-vpn'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/syafnurr/docker-vpn.git'
            }
        }

        stage('Prepare Config Files') {
            steps {
                script {
                    sh 'rm -rf vpn.ovpn'
                    sh 'rm -rf auth.txt'

                    writeFile(file: 'vpn.ovpn', text: sh(script: 'echo $OVPN_FILE | base64 -d', returnStdout: true).trim())
                    writeFile(file: 'auth.txt', text: sh(script: 'echo $AUTH_FILE | base64 -d', returnStdout: true).trim())
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Membuat Docker image dengan argumen build
                    sh """
                    docker build \
                        --build-arg VPN_CONFIG=vpn.ovpn \
                        --build-arg AUTH_CONFIG=auth.txt \
                        -t ${DOCKER_HUB_USERNAME}/${DOCKER_HUB_REPOSITORY}:${IMAGE_TAG} .
                    """
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    // Login ke Docker Hub
                    sh """
                    echo ${DOCKER_HUB_PASSWORD} | docker login -u ${DOCKER_HUB_USERNAME} --password-stdin
                    """
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Push Docker image ke Docker Hub
                    sh """
                    docker push ${DOCKER_HUB_USERNAME}/${DOCKER_HUB_REPOSITORY}:${IMAGE_TAG}
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Build and Push succeeded!"
        }
        failure {
            echo "Build or Push failed."
        }
    }
}
