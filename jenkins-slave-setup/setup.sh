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

curl -f -s -O /home/centos/agent.jar ${URL}/jnlpJars/agent.jar

#
java -jar /tmp/cli.jar -auth ${USERNAME}:${PASSWORD} -s ${URL} get-node ${AGENTNAME} &>dev/null
if [ $? -eq 0 ]; then
  echo -e "\e[1;31m Agent already exists, Use another Name\e[0m"
  exit 1
fi

#Create Agent with CLI
sed -e "s/AGENTNAME/${AGENTNAME}" node.xml  | java -jar /tmp/cli.jar -auth ${USERNAME}:${PASSWORD} -s ${URL} create-node ${AGENTNAME}

#Setup xml file with agent name - Done with node.xml file
type xq &>/dev/null
if [ $? -ne 0 ]; then
  echo -e "\e[1;31m xq is missing, Ensure you install xq"
  exit 2
fi

#Configure Agent with CLI
TOKEN=$(curl -s -u ${USERNAME}:${PASSWORD} ${URL}/computer/${AGENTNAME}/slave-agent.jnlp | sed -e 's|>| |g' -e 's|<| |g' | xargs -n1 | grep argument -A1 | grep -v argument  | head -1)



java -jar agent.jar -jnlpUrl http://172.31.40.19:8080/computer/agent1a/jenkins-agent.jnlp -secret 90731c613108a6ff64fc1fdf22074395b3be3a714058abc6b43b83c03d0aebfc -workDir "/home/centos"

sudo sed -e "s/URL/${URL}/" -e "s/AGENTNAME/${AGENTNAME}/" -e "s/TOKEN/${TOKEN}/" slave.service >/etc/systemd/system/jenkins-slave.service
sudo cp slave.service etc/systemd/service/jenkins-slave.service
sudo systemctl daemon-reload
sudo systemctl enable jenkins-slave
sudo systemctl start jenkins-slave

#Setup Jenkins startup script
