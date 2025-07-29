pipeline {
    agent any

    environment {
        DEPLOY_USER = "Sanu_Subhra"                       
        DEPLOY_HOST = "13.234.123.45"                   
        DEPLOY_PATH = "/var/www/html"                   
        SSH_KEY_ID  = "subhra.pem"                    
    }

    stages {
        stage('Clone Code') {
            steps {
                git 'https://github.com/Sanu-Subhra/welcome-webapp.git'
            }
        }

        stage('Test') {
            steps {
                sh './test.sh'
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent (credentials: [env.SSH_KEY_ID]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no $DEPLOY_USER@$DEPLOY_HOST 'sudo rm -rf $DEPLOY_PATH/*'
                        scp -o StrictHostKeyChecking=no index.html $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_PATH/
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
