pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'docker build -t karmashop:${GIT_COMMIT} .'
            }
        }
        stage('Test') {
            steps {
                sh 'echo "Running tests"'
                // Ajoutez ici vos commandes de test
            }
        }
        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-credentials') {
                        docker.image('karmashop:${GIT_COMMIT}').push()
                    }
                }
            }
        }
        stage('Deploy to Heroku') {
            steps {
                script {
                    // Commandes pour déployer sur Heroku
                }
            }
        }
    }
    post {
        always {
            mail to: 'notif-jenkins@joelkoussawo.me',
                 subject: "Build ${currentBuild.currentResult}: Job ${env.JOB_NAME}",
                 body: "Check console output at ${env.BUILD_URL} to view the results."
        }
    }
}
