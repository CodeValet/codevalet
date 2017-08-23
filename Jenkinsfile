#!/usr/bin/env groovy

pipeline {
    agent { label 'linux && docker' }
    stages {
        stage('Validate Terraform') {
            steps {
                echo 'Validating Terraform'
                sh 'make validate'
                echo 'Making sure we can generate our Kubernetes configurations'
                sh 'make generate-k8s'
            }
        }
        stage('Create builder') {
            steps {
                sh 'make builder'
            }
        }
        stage('Test') {
            steps {
                echo 'Maybe rtyler will write some tests'
            }
        }
    }
    post {
        always {
            sh 'make clean'
        }
    }
}
