pipeline {
    agent {
        docker {
            image 'python:3.8-alpine'
        }
    }

    environment {
        APP_NAME = 'flask_test_app'
    }

    stages {
        stage('Build Image') {
            steps {
                echo 'Build docker image'
                script {
                    app = docker.build("yzchg/$APP_NAME")
                    app.inside {
                        sh 'echo $(wget --spider localhost:5000)'
                    }
                }
            }
        }

        stage('Publish Image') {
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

        stage('Deploy To Production') {
            steps {
                input 'Deploy to Production?'
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
                        sshCommand remote: remote, command: "docker run --restart always --name $APP_NAME -dp 8081:8081 yzchg/$APP_NAME:latest"
                    }
                }
            }
        }
    }

}
