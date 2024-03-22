pipeline {
    environment {
        ID_DOCKER = "${ID_DOCKER_PARAMS}"
        IMAGE_NAME = "alpinehelloworld"
        IMAGE_TAG = "latest"
        // PORT_EXPOSED = "80" // Ce paramètre doit être configuré dans le job Jenkins
        STAGING = "${ID_DOCKER}-staging"
        PRODUCTION = "${ID_DOCKER}-production"
    }
    agent none
    stages {
        stage('Build image') {
            agent any
            steps {
                script {
                    sh 'docker build -t ${ID_DOCKER}/${IMAGE_NAME}:${IMAGE_TAG} .'
                }
            }
        }
        stage('Run container based on built image') {
            agent any
            steps {
                script {
                    sh '''
                        echo "Cleaning Environment"
                        docker rm -f ${IMAGE_NAME} || echo "Container does not exist"
                        docker run --name ${IMAGE_NAME} -d -p ${PORT_EXPOSED}:5000 -e PORT=5000 ${ID_DOCKER}/${IMAGE_NAME}:${IMAGE_TAG}
                        sleep 5
                    '''
                }
            }
        }
        stage('Test image') {
            agent any
            steps {
                script {
                    sh '''
                        curl http://172.17.0.1:${PORT_EXPOSED} | grep -q "Hello world!"
                    '''
                }
            }
        }
        stage('Clean Container') {
            agent any
            steps {
                script {
                    sh '''
                        docker stop ${IMAGE_NAME}
                        docker rm ${IMAGE_NAME}
                    '''
                }
            }
        }
        stage ('Login and Push Image on Docker Hub') {
            agent any
            environment {
                DOCKERHUB_PASSWORD = credentials('dockerhub')
            }
            steps {
                script {
                    sh '''
                        echo ${DOCKERHUB_PASSWORD} | docker login -u ${ID_DOCKER} --password-stdin
                        docker push ${ID_DOCKER}/${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                }
            }
        }
        stage('Push image in staging and deploy it') {
            when {
                expression { env.GIT_BRANCH == 'origin/master' }
            }
            agent any
            environment {
                HEROKU_API_KEY = credentials('heroku_api_key')
            }
            steps {
                script {
                    sh '''
                        npm i -g heroku@7.68.0
                        heroku container:login
                        heroku create ${STAGING} || echo "Project already exists"
                        heroku container:push -a ${STAGING} web
                        heroku container:release -a ${STAGING} web
                    '''
                }
            }
        }
        stage('Push image in production and deploy it') {
            when {
                expression { env.GIT_BRANCH == 'origin/production' }
            }
            agent any
            environment {
                HEROKU_API_KEY = credentials('heroku_api_key')
            }
            steps {
                script {
                    sh '''
                        npm i -g heroku@7.68.0
                        heroku container:login
                        heroku create ${PRODUCTION} || echo "Project already exists"
                        heroku container:push -a ${PRODUCTION} web
                        heroku container:release -a ${PRODUCTION} web
                    '''
                }
            }
        }
    }
}
