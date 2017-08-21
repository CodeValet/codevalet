#!/usr/bin/env groovy

pipeline {
    agent { label 'linux' }
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
                echo 'Maybe rtyler will write some tests'
            }
        }
    }
}
