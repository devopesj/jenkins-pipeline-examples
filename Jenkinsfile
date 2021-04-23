pipeline {
   agent{
      label 'ANSIBLE'
     }
  stages {
    stage('Hello'){
      steps{
        sh 'hostname'
        mail bcc: '', body: 'test', cc: '', from: '', replyTo: '', subject: 'test', to: 'ope.junaid@gmail.com'
     }
   }
   stage('Hello1') {
     steps {
       echo 'hello world 1'
       emailext body: 'test', subject: 'test', to: 'ope.junaid@gmail.com'
      }
    }
  }
}
