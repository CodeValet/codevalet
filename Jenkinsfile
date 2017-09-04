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
        stage('Create builder') {
            steps {
                sh 'make builder'
            }
        }
        stage('Build necessary plugins') {
            when { branch 'master' }
            steps {
                sh 'make plugins'
            }
        }
        stage('Create master container') {
            when { branch 'master' }
            steps {
                sh 'make master'
            }
            post {
                always {
                    archiveArtifacts artifacts: 'build/git-refs.txt', fingerprint: true
                }
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
