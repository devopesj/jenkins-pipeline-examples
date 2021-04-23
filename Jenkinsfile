pipeline {
   agent{
      label 'ANSIBLE'
     }
  stages {
    stage('Hello'){
      steps{
        sh 'hostname'
        slackSend channel: '#random', message: 'Hello'
     }
   }
   stage('Hello1') {
     steps {
       echo 'hello world 1'
       slackSend channel: '#random', message: 'Hello'
      }
    }
  }
}
