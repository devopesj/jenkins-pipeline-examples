#!/bin/bash

## Arguments needed are
# 1. IP adderss of Jenkins
# 2. Username
# 3. Password

USAGE() {
  echo -e "\e[1;31m Invalid Inputs\e[0m"
  echo -e "\e[1m $0 URL(http://IP:8080) USERNAME PASSWORD AGENTNAME \e[0m"
  exit 1
}

URL=$1
USERNAME=$2
PASSWORD=$3
AGENTNAME=$4

if [ -z "${URL}" -o -z "${USERNAME}" -o -z "${PASSWORD}" -o -z "${AGENTNAME}" ]; then
  USAGE
fi

#Install java
type java &>/dev/null
if [ $? -ne 0 ]; then
  echo -e "\e[1;31m Java is missing, Ensure you install Java"
  exit 2
fi
#Download cli jar file
curl -f -s -o /tmp/cli.jar ${URL}/jnlpJars/jenkins-cli.jar
if [ $? -ne 0 ]; then
  echo -e "\e[1;31m Unable to download Jenkins CLI"
  exit 2
fi

#
java -jar /tmp/cli.jar -auth ${USERNAME}:${PASSWORD} -s ${URL} get-node ${AGENTNAME} &>dev/null
if [ $? -ne 0 ]; then
  echo -e "\e[1;31m Agent already exists, Use another Name\e[0m"
  exit 1
fi

#Create Agent with CLI
sed -e "s/AGENTNAME/${AGENTNAME}" node.xml  | java -jar /tmp/cli.jar -auth ${USERNAME}:${PASSWORD} -s ${URL} create-node ${AGENTNAME}

#Setup xml file with agent name - Done with node.xml file
TOKEN=$(curl -s -u ${USERNAME}:${PASSWORD} ${URL}/computer/${AGENTNAME}/jenkins-agent.jnlp | sed -e 's/application-desc/appDesc/g' | xq .jnlp.appDesc.argument[0])

curl -f -s -O ${URL}/jnlpJars/agent.jar

java -jar agent.jar -jnlpUrl http://172.31.40.19:8080/computer/agent1a/jenkins-agent.jnlp -secret 90731c613108a6ff64fc1fdf22074395b3be3a714058abc6b43b83c03d0aebfc -workDir "/home/centos"

sudo sed -e "s/URL/${URL}/" -e "s/AGENTNAME/${AGENTNAME}/" -e "s/TOKEN/${TOKEN}/" slave.service >/etc/systemd/system/jenkins-slave.service
sudo systemctl daemon-reload
sudo systemctl enable jenkins-slave
sudo systemctl start jenkins-slave
#Configure Agent with CLI
#Setup Jenkins startup script
