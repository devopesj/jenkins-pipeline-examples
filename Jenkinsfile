pipeline {
   agent any

      environment {
        SURL = "global.example.com"
        SLACK_TOKEN = credentials('SLACK')
     }

  stages {
    stage('Hello'){
      environment{
      SURL = "local.example.com"
      }
      steps{
        sh 'echo ${SURL}'
        sh 'echo ${SLACK_TOKEN}'
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