pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Build flask app'
                sh "./Jenkins/build.sh"
            }
        }
        stage('Test') {
            steps {
                echo 'Test flask app'
                sh "./Jenkins/test.sh"
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploy flask app'
                sh "./Jenkins/deploy.sh"
            }
        }
    }

}
