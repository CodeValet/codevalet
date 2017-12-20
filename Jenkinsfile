#!/usr/bin/env groovy

pipeline {
    agent { label 'linux && docker' }
    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timeout(time: 3, unit: 'HOURS')
    }

    stages {
        stage('Validate Terraform') {
            steps {
                echo 'Validating Terraform'
                sh 'make validate'
                echo 'Making sure we can generate our Kubernetes configurations'
                sh 'make generate-k8s'
            }
        }
        stage('Test') {
            steps {
                sh 'make check'
            }
        }
    }
    post {
        always {
            sh 'make clean'
        }
    }
}
