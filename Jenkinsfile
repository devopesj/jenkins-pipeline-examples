pipeline {
   agent{
      label 'ANSIBLE'
     }
  stages {
    stage('Hello'){
      steps{
        sh 'sleep 30'
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
      slackSend channel: '#random', message: 'Hello'
    }
  }
}
