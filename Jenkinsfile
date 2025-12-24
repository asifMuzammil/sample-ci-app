pipeline {
    agent any

    environment {
        IMAGE_NAME = "sample-ci-app"
        GIT_SHA = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
        BUILD_DATE = sh(script: "date -u +%Y-%m-%dT%H:%M:%SZ", returnStdout: true).trim()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Unit Tests') {
            steps {
                sh '''
                  python3 -m venv .venv
                  . .venv/bin/activate
                  pip install -r requirements.txt
                  pytest -q
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh """
                  docker build -t ${IMAGE_NAME}:${GIT_SHA} \
                    --build-arg GIT_SHA=${GIT_SHA} \
                    --build-arg BUILD_DATE=${BUILD_DATE} \
                    --build-arg BUILD_NUMBER=${BUILD_NUMBER} .
                """
            }
        }

        stage('Smoke Test') {
            steps {
                sh '''
                docker run -d --rm --name ci-test \
                    -e CI_STAGE=jenkins_smoke \
                    -e GIT_SHA=${GIT_SHA} \
                    -e BUILD_DATE=${BUILD_DATE} \
                    -e BUILD_NUMBER=${BUILD_NUMBER} \
                    sample-ci-app:${GIT_SHA}

                # Wait briefly for gunicorn to start
                sleep 2

                # Run curl from a separate container that shares ci-test's network
                docker run --rm --network container:ci-test curlimages/curl:8.6.0 -fsS http://localhost:8080/health
                docker run --rm --network container:ci-test curlimages/curl:8.6.0 -fsS http://localhost:8080/version

                docker rm -f ci-test
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully"
        }
        failure {
            echo "❌ Pipeline failed"
        }
        always {
            sh "docker images | head -n 5"
        }
    }
}

