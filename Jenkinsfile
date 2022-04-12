pipeline {
    agent any

    tools { 
        maven 'Maven 3.8.4' 
    }
    
    environment {
        AWS_ID = credentials("aws.id")
        AWS_DEFAULT_REGION = credentials("deployment.region")
        MICROSERVICE_NAME = "bank-microservice-js"
    }

    stages {
        stage ('Initialize') {
            steps {
                // Verify path variables for mvn
                sh '''
                    echo "Preparing to build, test and deploy ${MICROSERVICE_NAME}"
                    echo "PATH = ${PATH}"
                    echo "M2_HOME = ${M2_HOME}"
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
                    docker.withRegistry("https://${AWS_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com", "ecr:${AWS_DEFAULT_REGION}:jenkins.aws.credentials.js") {
                        def image = docker.build("${MICROSERVICE_NAME}")
                        image.push('latest')
                    } 
                }  
            }
        }

        stage('Deploy'){
            steps {    
                sh "docker compose up -d"            
            }
        }

        stage('Cleanup') {
            steps {
                sh "docker image rm ${MICROSERVICE_NAME}:latest"
                sh 'docker image rm $AWS_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$MICROSERVICE_NAME'
                sh "docker image prune -f"
            }
        }
    }
}
