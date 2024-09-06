pipeline {
    agent any

    stages {
        stage('Install') {
            steps {
                echo 'Installing dependencies...'
                pwsh '''
                yarn install
                '''
            }
        }
        stage('Linting') {
            steps {
                echo 'Linting...'
                pwsh '''
                yarn biome lint
                '''
            }
        }
        stage('Formatting') {
            steps {
                echo 'Formatting...'
                pwsh '''
                yarn biome format
                '''
            }
        }
        stage('Build') {
            steps {
                echo 'Building...'
                pwsh '''
                yarn build
                '''
            }
        }
    }
}
