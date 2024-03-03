pipeline {
    agent any

    environment {
        DOCKERHUB_USER="yasinkartal"
        APP_REPO_NAME = "todo-app"      
        DB_VOLUME="myvolume123"
        NETWORK="my_network"   
        POSTGRES_PASSWORD= "Pp123456789" 
        DOCKER_IMAGE="yasinkartal/todo-app"   
    }

    stages {
        stage('Build App Docker Image') {
            steps {
                echo 'Building App Image'
                sh 'docker build --force-rm -t "$DOCKERHUB_USER/$APP_REPO_NAME:postgre" -f ./database/Dockerfile .'
                sh 'docker build --force-rm -t "$DOCKERHUB_USER/$APP_REPO_NAME:nodejs" -f ./server/Dockerfile .'
                sh 'docker build --force-rm -t "$DOCKERHUB_USER/$APP_REPO_NAME:react" -f ./client/Dockerfile .'
                sh 'docker image ls'
            }
        }
    stage('Push Image Docker Hub') {
            steps {
                echo 'Push Image Docker Hub'
                sh 'docker login -u yasinkartal -p dckr_pat_QCOcHihdVP0NylqtKQ_5pAkGqLM'
                sh 'docker push "$DOCKERHUB_USER/$APP_REPO_NAME:postgre"'
                sh 'docker push "$DOCKERHUB_USER/$APP_REPO_NAME:nodejs"'
                sh 'docker push "$DOCKERHUB_USER/$APP_REPO_NAME:react"'
            }
        }
        stage('create volume') {
            steps {
                echo 'create the volume for app and container'
                sh 'docker volume create $DB_VOLUME'
             }
        }
        stage('create network') {
            steps {
                echo 'creating the network for app and all containers'
                sh 'docker network create $NETWORK'
             }
        }
        stage('Deploy the postgre') {
            steps {
                echo 'Deploy the postgre database'
                sh 'docker run --name db -p 5432:5432 -v $DB_VOLUME:/var/lib/postgresql/data --network $NETWORK -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD --restart always -d $DOCKERHUB_USER/$APP_REPO_NAME:postgre' 
            }
        }
        stage('wait the postgre database') {
            steps {
                script {
                    echo 'Waiting for the postgre database docker container'
                    sh 'sleep 60s'
                }
            }
        }
        stage('Deploy the node_js_server') {
            steps {
                echo 'Deploy the server'
                sh 'docker run --name server -p 5000:5000  --network $NETWORK --restart always -d $DOCKERHUB_USER/$APP_REPO_NAME:nodejs' 
            }
        }
        stage('wait the server') {
            steps {
                script {
                    echo 'Waiting for the server container'
                    sh 'sleep 30s'
                }
            }
        }
        stage('Deploy the client') {
            steps {
                echo 'Deploy the client'
                sh 'docker run --name client -p 3000:3000  --network $NETWORK --restart always -d $DOCKERHUB_USER/$APP_REPO_NAME:react' 
            }
        }
        stage('Docker Container Stop') {
            steps {
                timeout(time:5, unit:'DAYS') {
                    input message:'Approve terminate'
                }
                sh 'docker rm -f $(docker ps -aq)' 
            }
        }
        stage('DELETE image, volume, network') {
            steps {
                timeout(time:5, unit:'DAYS') {
                    input message:'Approve terminate'
                }
                sh 'docker rmi -f $DOCKER_IMAGE:postgre $DOCKER_IMAGE:nodejs $DOCKER_IMAGE:react'
                sh 'docker network rm $NETWORK'
                sh 'docker volume rm $DB_VOLUME'

            }
        }
    }

    post {
        success {
            script {
                slackSend channel: '#class-chat', color: '#439FE0', message: ' Project-207 with Jenkins, Docker, Docker Compose, and Docker Hub ', teamDomain: 'devops15tr', tokenCredentialId: '207'
            }
        }
    }
}
