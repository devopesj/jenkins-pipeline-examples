// pipeline {
//    agent any
//
//       environment {
//         SURL = "global.example.com"
//         SLACK_TOKEN = credentials('SLACK')
//      }
//
//      triggers{
//      pollSCM('* * * * *')}
//
//      tools {
//        nodejs 'node-16'
//        }
//
//      options{
//      disableConcurrentBuilds()
//      }
//       parameters {
//       string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')
//       text(name: 'BIOGRAPHY', defaultValue: '', description: 'Enter some information about the person')
//       booleanParam(name: 'PROD', defaultValue: false, description: 'Runs Prod stage if chosen')
//       choice(name: 'CHOICE', choices: ['One', 'Two', 'Three'], description: 'Pick something')
//       password(name: 'PASSWORD', defaultValue: 'SECRET', description: 'Enter a password')
//           }
//
//
//   stages {
//     stage('Hello'){
//       environment{
//       SURL = "local.example.com"
//       }
//       steps{
//         sh 'node --version'
//      }
//    }
//    stage('PROD') {
//    when {
//       expression{
//       params.PROD
//       }
//    }
// //  input {
// //          message "Should we continue?"
// //          ok "Yes, we should."
// //          submitter "admin"
// //    }
//      steps {
//        echo 'hello world 1'
//       }
//     }
//     stage('Parallel stages') {
//     parallel {
//       stage('P1'){
//         steps {
//           sh 'sleep 100'
//           }
//         }
//           stage('P2'){
//             steps {
//               sh 'sleep 110'
//               }
//             }
//           }
//        }
//     }
//   post{
//     aborted{
//       slackSend channel: '#random', message: "Failed Job - URL = ${SURL}"
//     }
//     always{
//       slackSend channel: '#random', message: "Aborted Job - URL = ${SURL}"
//     }
//   }
// }

matrix {
    axes {
        axis {
            name 'PLATFORM'
            values 'linux', 'mac', 'windows'
        }
    }
    stages {
        stage('build') {
           steps{
           sh 'echo hello'
           }
        }
        stage('test') {
           steps{
             sh 'echo hello'
             }
        }
        stage('deploy') {
           steps{
             sh 'echo hello'
            }
        }
       }
     }