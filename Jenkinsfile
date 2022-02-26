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
        sh 'cat "$BRANCH_NAME.tfvars'
        sh 'terraform init -no-color'
      }
    }

    stage('Plan') {
      steps {
        sh 'terraform plan -no-color'
      }
    }
    
    stage('Validate Apply') {
      when {
        beforeInput true
        branch "dev"
      }
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
        sh 'terraform apply --auto-approve -no-color -var-file="$BRANCH_NAME.tfvars"'
      }
    }
    
    stage('Ec2 wait') {
      steps {
        sh 'aws ec2 wait instance-status-ok --region eu-west-2'
      }
    }
    
    stage('Validate Ansible') {
      when {
        beforeInput true
        branch "dev"
      }
      input {
        message "Do you want to run Ansible?"
        ok "Run Ansible!"
      }
      steps {
        echo 'Ansible Accepted'
      }
     }
 
    stage('Ansible') {
      steps {
        ansiblePlaybook(credentialsId: 'ubuntu-local', inventory: 'aws_hosts', playbook: 'playbooks/main-playbook.yml', disableHostKeyChecking: true, colorized: true)
      }
    }   
    
    stage('Validate Destroy') {
      input {
        message "Do you want to tear down environment?"
        ok "Tear down env now!"
      }
      steps {
        echo 'Ansible Destroyed resources'
      }
    }
    
    stage('Destroy') {
      steps {
        sh 'terraform destroy --auto-approve -no-color -var-file="$BRANCH_NAME.tfvars'  
      }

    } 
  }
  post {
    success {
      echo 'Success!'
    }
    failure { 
      sh 'terraform destroy --auto-approve -no-color -var-file=$BRANCH_NAME.tfvars'
    }
  } 
}
