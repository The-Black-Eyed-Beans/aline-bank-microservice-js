pipeline {
    agent any

    tools { 
        maven 'Maven 3.8.4' 
    }

    stages {
        stage ('Initialize') {
            steps {
                // Verify path variables for mvn
                sh '''
                    echo "PATH = ${PATH}"
                    echo "M2_HOME = ${M2_HOME}"
                ''' 
            }
        }
        
        stage('Build') {
            steps {
                sh "git submodule init && git submodule update"
                sh "mvn install"
            }
        }
        stage('Dockerize') {
            steps {
                script{
                    image = '''docker.build bank-microservice-js'''
                }
            }
        }
        stage('Push') {
            
            steps {
                script {
                    docker.withRegistry("https://086620157175.dkr.ecr.us-west-1.amazonaws.com", "ecr:us-west-1:jenkins.aws.credentials.js") {
                        def image = docker.build('bank-microservice-js')
                        image.push('latest')
                    } 
                }  
            }
            
        }
    }
}
