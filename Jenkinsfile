pipeline {
    agent any

    stages {
        stage('Install') {
            steps {
                echo 'Installing dependencies...'
                sh 'yarn install'
            }
        }
        stage('Linting') {
            steps {
                echo 'Linting...'
                sh 'yarn biome lint'
            }
        }
        stage('Formatting') {
            steps {
                echo 'Formatting...'
                sh 'yarn biome format'
            }
        }
        stage('Build') {
            steps {
                echo 'Building...'
                sh 'yarn build'
            }
        }
    }
}
