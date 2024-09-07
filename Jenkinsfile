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
        stage('Generating SBOM') {
            steps {
                echo 'Switching to Yarn 4.4.1...'
                pwsh '''
                yarn set version 4.4.1
                '''

                echo 'Installing cyclonedx...'
                pwsh '''
                yarn add --dev @cyclonedx/yarn-plugin-cyclonedx
                '''

                echo 'Generating SBOM...'
                pwsh '''
                yarn cyclonedx --spec-version 1.4 --output-format json --output-file --production ./sbom.json
                '''
                                
                echo 'Switching back to Yarn classic...'
                pwsh '''
                yarn set version 1.22.22
                '''
            }
        }
        stage('Putting SBOM to Dependency-Track') {
            steps {
                echo 'Putting SBOM to Dependency-Track...'
                pwsh '''
                curl -X "PUT" "http://localhost:8082/api/v1/bom" \
                    -H 'Content-Type: application/json' \
                    -H 'X-API-Key: odt_hDA8EDlbnAslMQwj4jWbsGEvVxpfJRlS' \
                    -d @sbom.json
                '''
            }
        }
        stage('Testing') {
            steps {
                echo 'Testing...'
                pwsh '''
                yarn test
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
