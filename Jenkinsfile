pipeline {
    agent any

    environment {
        APP_NAME = 'flask_test_app'
    }

    stages {

        stage('Package source code') {
            steps {
                sh '''
                   rm -rf dist && mkdir dist
                   tar cvzf dist/flask_test_app.tar.gz docker-compose.yml Dockerfile app/ nginx/
                '''
            }
        }

        stage('Deploy source code and run docker-compose') {
            steps {
                milestone(1)
                withCredentials([usernamePassword(credentialsId: 'vm1_ssh_userpass', usernameVariable: 'USERNAME', passwordVariable: 'USERPASS')]) {
                    script {
                        def remote = [:]
                        remote.name = 'node1'
                        remote.host = env.node1_ip
                        remote.user = USERNAME
                        remote.password = USERPASS
                        remote.allowAnyHosts = true
                        script {
                            sshPut remote: remote, from: 'dist/flask_test_app.tar.gz', into: '/tmp'
                            sshCommand remote: remote, command: """
                                . ~/.profile &&
                                cd /tmp &&
                                tar xvzf flask_test_app.tar.gz &&
                                docker-compose up -d --build
                            """
                        }
                    }
                }
            }
        }

    }

}
