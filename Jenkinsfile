pipeline {
    agent any

    stages {
        stage('Build Image') {
            steps {
                script {
                    sh 'sudo usermod -aG docker $USER'
                    sh 'sudo docker run hello-world'
                    sh 'sudo docker build -t haunguyen42195/ou-smartlocker-web-admin .'
                }
            }
        }
        stage('Push Image To DockerHub') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'dockerhub-pwd', variable: 'dockerhubpwd')]) {
                        sh "sudo docker login -u haunguyen42195@gmail.com -p ${dockerhubpwd}"
                    }
                    sh 'sudo docker push haunguyen42195/ou-smartlocker-web-admin'
                }
            }
        }
        stage('Deploy on server') {
            steps {
                script {
                    sh '''
                        sudo docker ps
                        sudo docker stop smartlocker-web-admin
                        sudo docker rm smartlocker-web-admin
                        sudo docker pull haunguyen42195/ou-smartlocker-web-admin
                        sudo apt install docker-compose
                        ls
                        sudo docker-compose -f /root/docker-compose.yml up -d
                        sudo docker ps
                    '''
                }
            }
        }
    }
}