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
                    script {
                        env.IMAGE_PATH = env.IMAGE + ":" + env.IMAG_TAG
                    }
                    sh '''
                    docker build -t $IMAGE_PATH .
                    '''
                }
            }
        }

        stage('push image') {
            steps {
                container('base') {
                    script {
                        env.IMAGE_PATH = env.IMAGE + ":" + env.IMAG_TAG
                    }
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        sh '''
                        docker login -u$USER -p$PASS
                        docker push $IMAGE_PATH
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