pipeline {
   agent any

      environment {
        SURL = "global.example.com"
     }
  stages {
    stage('Hello'){
      steps{
        sh 'echo ${SURL}'
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
      slackSend channel: "#random', message: 'Failed Job - URL = ${SURL}"
    }
    always{
      slackSend channel: "#random', message: 'Aborted Job - URL = ${SURL}"
    }
  }
}