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
                        env.IMAG_TAG = 'dev'
                        echo '4'
                    } else {
                        env.IMAG_TAG = env.TAG_NAME
                    }
                }
                echo "${env.IMAG_TAG}"
            }
        }

        stage('build image') {
            steps {
                container('base') {
                    sh '''
                    docker build -t "${env.IMAGE}:${env.IMAG_TAG}" .
                    '''
                }
            }
        }

        stage('push image') {
            steps {
                container('base') {
                    withCredentials([usernamePassword(credentialsId: 'github', usernameVariable: 'USER', passwordVariable: 'PWD')]) {
                        sh '''
                        docker login -u$USER -p$PWD
                        docker push -t "${env.IMAGE}:${env.IMAG_TAG}" .
                        '''
                    }
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