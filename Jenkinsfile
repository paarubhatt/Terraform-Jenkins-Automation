pipeline {

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Choose whether to apply or destroy resources')
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

        stage('Apply or Destroy') {
            steps {
                script {
                    if (params.action == 'apply') {
                        echo "Applying Terraform plan..."
                        sh 'terraform apply -input=false tfplan'
                    } else if (params.action == 'destroy') {
                        input message: "Are you sure you want to destroy the resources?",
                        parameters: [
                            booleanParam(name: 'confirmDestroy', defaultValue: false, description: 'Confirm resource destruction')
                        ]
                        if (params.confirmDestroy) {
                            echo "Destroying Terraform resources..."
                            sh 'terraform destroy -auto-approve'
                        } else {
                            echo "Destroy process cancelled."
                        }
                    } else {
                        error("Invalid action: ${params.action}")
                    }
                }
            }
        }
    }
}
