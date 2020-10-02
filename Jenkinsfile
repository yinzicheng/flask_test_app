pipeline {
    agent {
        docker {
            image 'python:3.8-alpine'
        }
    }

    stages {
        stage('Build') {

            steps {
                echo 'Build flask app'
                sh "chmod u+x ./Jenkins/*.sh && ls -al ./Jenkins"
                sh "sudo ./Jenkins/build.sh"
            }
        }

        stage('Test') {
            steps {
                echo 'Test flask app'
                sh "sudo ./Jenkins/test.sh"
            }
        }

//        stage('Deploy') {
//            steps {
//                echo 'Deploy flask app'
//                sh "./Jenkins/deploy.sh"
//            }
//        }
    }

}
