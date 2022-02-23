pipeline {
  agent any
  
  environment {
    TF_IN_AUTOMATION = 'true'
    TF_CLI_CONFIG_FILE = credentials('tfc-secret')
  }  

  stages {
    stage('Init') {
      steps {
        sh 'ls'
        sh 'terraform init -no-color'
      }
    }

    stage('Plan') {
      steps {
        sh 'terraform plan -no-color'
      }
    }

    stage('Apply') {
      steps {
        sh 'terraform apply --auto-approve -no-color'
      }
    }
    
    stage('Ec2 wait') {
      steps {
        sh 'aws ec2 wait instance-status-ok --region -eu-west-2'
      }
    }

    stage('Destroy') {
      steps {
        sh 'terraform destroy --auto-approve -no-color'  
      }

    } 
  } 
}
