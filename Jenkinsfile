pipeline {
    agent any

    environment {
        APP_NAME = 'flask_test_app'
    }

    stages {
        stage('1. Build Image') {
            steps {
                echo 'Build docker image'
                script {
                    app = docker.build("yzchg/$APP_NAME")
                    app.inside {
                        sh 'echo $(wget --spider localhost:8082 && netstat -tulpn | grep LISTEN)'
                    }
                }
            }
        }

        stage('2. Publish Image') {
            steps {
                echo 'Publish Docker Image to Dockerhub'
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker_hub_login') {
                        // app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }

        stage('3. Deploy To Production') {
            steps {
                // input 'Deploy to Production?'
                milestone(1)
                withCredentials([usernamePassword(credentialsId: 'node1_ssh_userpass', usernameVariable: 'USERNAME', passwordVariable: 'USERPASS')]) {
                    script {
                        def remote = [:]
                        remote.name = 'node1'
                        remote.host = env.node1_ip
                        remote.user = USERNAME
                        remote.password = USERPASS
                        remote.allowAnyHosts = true
                        try {
                            sshCommand remote: remote, command: "docker rm -f $APP_NAME"
                        } catch (err) {
                            echo: 'caught error: $err'
                        }
                        sshCommand remote: remote, command: '''
                            docker pull yzchg/$APP_NAME:latest &&
                            docker run --restart always --name $APP_NAME -dp 8082:8082 yzchg/$APP_NAME:latest
                            '''
                    }
                }
            }
        }
    }

}
