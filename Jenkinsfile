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
                        sh 'echo $(wget --spider localhost:5000)'
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

        stage('Deploy app to k8s cluster') {
            steps {
                milestone(1)
                withCredentials([usernamePassword(credentialsId: 'vm1_ssh_userpass', usernameVariable: 'USERNAME', passwordVariable: 'USERPASS')]) {
                    script {
                        def remote = [:]
                        remote.name = 'vm1'
                        remote.host = env.vm1_ip
                        remote.user = USERNAME
                        remote.password = USERPASS
                        remote.allowAnyHosts = true
                        script {
                            sshPut remote: remote, from: 'dist/flask_test_app.tar.gz', into: '/tmp'
                            sshCommand remote: remote, command: """
                                . ~/.profile && id && 
                                rm -rf $APP_DIR && mkdir -p $APP_DIR && cd $APP_DIR && cp /tmp/flask_test_app.tar.gz $APP_DIR && 
                                tar xvzf $APP_DIR/flask_test_app.tar.gz && 
                                docker-compose -f $APP_DIR/docker-compose.yml down && 
                                docker-compose -f $APP_DIR/docker-compose.yml up -d --build
                            """
                        }
                    }
                }
            }
        }

    }

    post {
        success {
            archiveArtifacts artifacts: 'dist/flask_test_app.tar.gz'
        }
    }

}
