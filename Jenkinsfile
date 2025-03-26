pipeline {

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        booleanParam(name: 'destroyFlag', defaultValue: true, description: 'Set to true to destroy resources after apply')
    } 
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    agent any
    stages {
        stage('Checkout') {
            steps {
                script {
                    git branch: 'master', url: 'https://github.com/paarubhatt/Terraform-Jenkins-Automation.git'
                }
            }
        }

        stage('Plan') {
            steps {
                sh 'terraform init'
                sh 'terraform plan -out=tfplan'
                sh 'terraform show -no-color tfplan > tfplan.txt'
            }
        }

        stage('Approval') {
            when {
                not {
                    equals expected: true, actual: params.autoApprove
                }
            }
            steps {
                script {
                    def plan = readFile 'tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }

        stage('Apply') {
            when {
                expression {
                    return params.destroyFlag == false
                }
            }
            steps {
                sh 'terraform apply -input=false tfplan'
            }
        }

        stage('Destroy') {
            when {
                expression {
                    return params.destroyFlag == true
                }
            }
            steps {
                script {
                        sh 'terraform destroy -auto-approve'
                }
            }
        }
    }
}
