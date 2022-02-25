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
    
    stage('Validate Apply') {
      input {
        message "Do you want to apply this plan?"
        ok "Apply this plan"
      }
      steps {
        echo 'Apply Accepted'
      }
    }
    

    stage('Apply') {
      steps {
        sh 'terraform apply --auto-approve -no-color'
      }
    }
    
    stage('Ec2 wait') {
      steps {
        sh 'aws ec2 wait instance-status-ok --region eu-west-2'
      }
    }
    
    stage('Ansible') {
      input {
        message "Should Ansible run?"  
        ok "Run Ansible"
      }
      steps {
        ansiblePlaybook(credentialsId: 'ubuntu-local', inventory: 'aws_hosts', playbook: 'playbooks/main-playbook.yml', disableHostKeyChecking: true, colorized: true)
      }
    }   

    stage('Destroy') {
      input {
        message "Do you want to destroy resources?"
        ok "Tear down environment"
      }
      steps {
        sh 'terraform destroy --auto-approve -no-color'  
      }

    } 
  } 
}
