pipeline {
    agent any

    options {
        // This is required if you want to clean before build
        skipDefaultCheckout(true)
    }

    stages {
        stage('Checkout') {
            steps {
                // Clean before build
                cleanWs()
                // We need to explicitly checkout from SCM here
                checkout scm
            }
        }
    }

    stages {        
        stage('Generating SBOM') {
            steps {
                echo 'Switching to Yarn 4.4.1...'
                pwsh '''
                yarn set version 4.4.1
                yarn install
                '''

                echo 'Installing cyclonedx...'
                pwsh '''
                yarn add --dev @cyclonedx/yarn-plugin-cyclonedx
                '''

                echo 'Generating SBOM...'
                pwsh '''
                yarn exec cyclonedx-yarn --spec-version 1.4 --output-format "JSON" --output-file ./sbom.json --production 
                '''
            }
        }
        stage('Putting SBOM to Dependency-Track') {
            steps {
                echo 'Putting SBOM to Dependency-Track...'
                pwsh '''
                $json = Get-Content -Path '.\sbom.json' -Encoding byte

                $ApiKey = 'odt_hDA8EDlbnAslMQwj4jWbsGEvVxpfJRlS'
                $Header = @{'X-API-Key' = $ApiKey}
                $Uri = 'http://localhost:8082/api/v1/bom'

                $Body = ([PSCustomObject]@{
                    projectName = $env:JOB_NAME
                    projectVersion = $env:BUILD_NUMBER
                    autoCreate = 'true'
                    bom = ([Convert]::ToBase64String($json))
                } | ConvertTo-Json)

                Invoke-RestMethod -Method Put -Uri $Uri -Headers $Header -ContentType 'application/json' -Body $Body
                '''
            }
        }
        stage('Install') {
            steps {
                echo 'Switching back to Yarn classic...'
                pwsh '''
                yarn set version 1.22.22
                '''

                echo 'Installing dependencies...'
                pwsh '''
                yarn install
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
                
                echo 'Building ${env.JOB_NAME}...'
                pwsh '''
                yarn build
                '''
            }
        }
        post {
            // Clean after build
            always {
                cleanWs(cleanWhenNotBuilt: false,
                        deleteDirs: true,
                        disableDeferredWipeout: true,
                        notFailBuild: true,
                        patterns: [[pattern: '.gitignore', type: 'INCLUDE'],
                                [pattern: '.propsfile', type: 'EXCLUDE']])
            }
        }
    }
}
