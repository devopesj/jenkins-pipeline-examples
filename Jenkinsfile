pipeline {
   agent any

      environment {
        SURL = "global.example.com"
        SLACK_TOKEN = credentials('SLACK')
     }

     triggers{
     pollSCM('* * * * *')}

     tools {
       nodejs 'node-16'
       }

     options{
     disableConcurrentBuilds()
     }
      parameters {
      string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')
      text(name: 'BIOGRAPHY', defaultValue: '', description: 'Enter some information about the person')
      booleanParam(name: 'TOGGLE', defaultValue: true, description: 'Toggle this value')
      choice(name: 'CHOICE', choices: ['One', 'Two', 'Three'], description: 'Pick something')
      password(name: 'PASSWORD', defaultValue: 'SECRET', description: 'Enter a password')
          }


  stages {
    stage('Hello'){
      environment{
      SURL = "local.example.com"
      }
      steps{
        sh 'node --version'
     }
   }
   stage('Hello1') {
     steps {
       echo 'hello world 1'
      }
    }
  }
  post{
    aborted{
      slackSend channel: '#random', message: "Failed Job - URL = ${SURL}"
    }
    always{
      slackSend channel: '#random', message: "Aborted Job - URL = ${SURL}"
    }
  }
}