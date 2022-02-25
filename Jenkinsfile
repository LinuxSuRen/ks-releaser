pipeline {
    agent {
        label 'base'
    }

    environment {
        IMAGE = 'surenpi/ks-releaser'
    }

    stages {
        stage('test') {
            steps {
                echo env.BRANCH_NAME
                echo env.TAG_NAME
            }
        }

        stage('build image') {
            steps {
                sh '''
                docker build -t ${IMAGE} .
                '''
            }
        }

        stage('push image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'github', usernameVariable: 'USER', passwordVariable: 'PWD')]) {
                    sh '''
                    docker login -u$USER -p$PWD
                    docker push -t ${IMAGE} .
                    '''
                }
            }
        }

        stage('update gitops') {
            when {
                tag "release-*"
            }
            steps {
                echo env.TAG_NAME
            }
        }
    }
}