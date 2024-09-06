pipeline {
    agent any

    stages {
        stage('Install') {
            steps {
                sh 'yarn install'
            }
        }
        stage('Lint and format') {
            steps {
                sh 'yarn biome lint'
            }
            steps {
                sh 'yarn biome format'
            }
        }
        stage('Build') {
            steps {
                sh 'yarn build'
            }
        }
    }
}
