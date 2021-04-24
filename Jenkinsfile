pipeline {
   agent{
      label 'ANSIBLE'

      environment {
        URL = 'global.example.com'}
     }
  stages {
    stage('Hello'){
      steps{
        sh 'echo ${URL}'
     }
   }
   stage('Hello1') {
     steps {
       echo 'hello world 1'
      }
    }
  }
  post{
    failed{
      slackSend channel: '#random', message: 'Failed Job - URL = ${URL}'
    }
    aborted{
      slackSend channel: '#random', message: 'Aborted Job - URL = ${URL}'
    }
  }
}
