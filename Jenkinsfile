pipeline {
    agent any

    environment {
        DOCKERHUB_USER = "yasinkartal"
        APP_REPO_NAME = "todo-app"
        DB_VOLUME = "myvolume"
        NETWORK = "mynetwork"
    }

    stages {
        stage('Install dockerize') {
            steps {
                script {
                    // 'wget' komutu yardımıyla dockerize aracını indirin
                    sh 'wget https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-linux-amd64-v0.6.1.tar.gz'
                    // İndirdiğiniz arşiv dosyasını açın
                    sh 'tar -xzvf dockerize-linux-amd64-v0.6.1.tar.gz'
                    // Dockerize'ı uygun bir dizine taşıyın (örneğin /usr/local/bin)
                    sh 'sudo mv dockerize /usr/local/bin'
                }
            }
        }
        
        // Diğer aşamaları buraya ekleyin
    }
}

    stages {
        stage('Build App Docker Image') {
            steps {
                echo 'Building App Image'
                sh "docker build --force-rm -t $DOCKERHUB_USER/$APP_REPO_NAME:postgre -f ./database/Dockerfile ."
                sh "docker build --force-rm -t $DOCKERHUB_USER/$APP_REPO_NAME:nodejs -f ./server/Dockerfile ."
                sh "docker build --force-rm -t $DOCKERHUB_USER/$APP_REPO_NAME:react -f ./client/Dockerfile ."
                sh "docker image ls"
            }
        }

        stage('Push Image to Dockerhub Repo') {
            steps {
                echo 'Pushing App Image to DockerHub Repo'
                withCredentials([string(credentialsId: 'My_Docker_Hub_Token', variable: 'DOCKER_HUB')]) {
                    sh "docker login -u $DOCKERHUB_USER -p $DOCKER_HUB"
                    sh "docker push $DOCKERHUB_USER/$APP_REPO_NAME:postgre"
                    sh "docker push $DOCKERHUB_USER/$APP_REPO_NAME:nodejs"
                    sh "docker push $DOCKERHUB_USER/$APP_REPO_NAME:react"
                }
            }
        }

        stage('Create Volume') {
            steps {
                echo 'Creating the volume for app and db containers.'
                sh "docker volume create $DB_VOLUME"
            }
        }

        stage('Create Network') {
            steps {
                echo 'Creating the network for app and db containers.'
                sh "docker network create $NETWORK"
            }
        }

        stage('Deploy the DB') {
            steps {
                echo 'Deploying the DB'
                withCredentials([string(credentialsId: 'project-207-postgre-password', variable: 'POSTGRES_PASSWORD')]) {
                    sh "docker run --name db -p 5432:5432 -v $DB_VOLUME:/var/lib/postgresql/data --network $NETWORK -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD --restart always -d $DOCKERHUB_USER/$APP_REPO_NAME:postgre"
                }
            }
        }

        stage('Wait for the DB') {
            steps {
                echo 'Waiting for the DB container'
                sh './dockerize -wait tcp://localhost:5432 -timeout 60s'
                
            }
        }

        stage('Deploy the server') {
            steps {
                echo 'Deploying the server'
                sh "docker run --name server -p 5000:5000 --network $NETWORK --restart always -d $DOCKERHUB_USER/$APP_REPO_NAME:nodejs"
            }
        }

        stage('Wait for the server') {
            steps {
                echo 'Waiting for the server container'
                sh './dockerize -wait tcp://server:5000 -timeout 600s'
            }
        }

        stage('Deploy the client') {
            steps {
                echo 'Deploying the client'
                sh "docker run --name client -p 3000:3000 --network $NETWORK --restart always -d $DOCKERHUB_USER/$APP_REPO_NAME:react"
            }
        }

        stage('Destroy the infrastructure') {
            steps {
                timeout(time: 5, unit: 'DAYS') {
                    input message: 'Approve terminate'
                }
                echo 'All the resources will be cleaned up in the next step...'
                script {
                    sh 'docker container ls && docker images && docker network ls && docker volume ls'
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up'
            script {
                sh 'docker rm -f $(docker container ls -aq)'
                sh 'docker rmi -f $(docker images -q)'
                sh "docker network rm $NETWORK"
                sh "docker volume rm $DB_VOLUME"
            }
        }

        success {
            echo 'Pipeline executed successfully'
            sh 'echo "SUCCESS"'
        }

        failure {
            echo 'Pipeline failed. Cleaning up containers, images, network, and volume.'
            sh 'echo "FAILURE"'
        }
    }
}
