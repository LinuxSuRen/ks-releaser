pipeline {
    agent {
        label 'base'
    }

    environment {
        IMAGE = 'surenpi/ks-releaser'
        TAG = ''
    }

    stages {
        stage('test') {
            steps {
                script {
                    if (env.BRANCH_NAME != null) {
                        echo '1'
                    }
                    if (env.BRANCH_NAME != '') {
                        echo '2'
                    }
                    if (env.BRANCH_NAME != "") {
                        echo '3'
                    }

                    if (env.BRANCH_NAME != null && env.BRANCH_NAME != '') {
                        env.TAG = 'dev'
                        echo '4'
                    } else {
                        env.TAG = env.TAG_NAME
                    }
                }
                echo env.TAG
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