pipeline {
    agent any

    tools { 
        maven 'Maven 3.8.4' 
    }
    
    environment {
        AWS_ID = credentials("aws.id")
        DEPLOYMENT_REGION = "us-west-1"
    }

    stages {
        stage ('Initialize') {
            steps {
                // Verify path variables for mvn
                sh '''
                    echo "PATH = ${PATH}"
                    echo "M2_HOME = ${M2_HOME}"
                    echo "ID = ${AWS_ID}"
                ''' 
            }
        }
        
        stage('Build') {
            steps {
                sh "git submodule init"
                sh "git submodule update"
                sh "mvn install -Dmaven.test.skip=true"
            }
        }
        stage('Test') {
            steps {
                echo 'Testing happens here.'
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
        stage('Cleanup') {
            steps {
                sh "docker image rm bank-microservice-js:latest"
                sh "docker image rm 086620157175.dkr.ecr.us-west-1.amazonaws.com/bank-microservice-js"
                sh "docker image ls"
            }
        }
    }
}
