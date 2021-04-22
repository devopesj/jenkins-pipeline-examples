pipeline {
   agent{
      label 'ANSIBLE'
     }
  stages {
    stage('Hello'){
      steps{
        sh 'hostname'
     }
   }
   stage('Hello1') {
     steps {
       echo 'hello world 1'
      }
    }
  }
}
