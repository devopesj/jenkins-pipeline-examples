#!/bin/bash

## Arguments Needed are
# 1. Ip Address of Jenkins , Ex : http://IPadd:port
# 2. Username
# 3. Password

USAGE() {
  echo -e "\e[1;31m Invalid Inputs\e[0m"
  echo -e "\e[1m $0 URL(http://IP:8080) USERNAME PASSWORD AGENTNAME \e[0m"
  exit 1
}

## Load Arguments
URL=$1
USERNAME=$2
PASSWORD=$3
AGENTNAME=$4

if [ -z "${URL}" -o -z "${USERNAME}" -o -z "${PASSWORD}" -o -z "${AGENTNAME}"  ]; then
  USAGE
fi

# Check Java
type java &>/dev/null
if [ $? -ne 0 ]; then
  echo -e "\e[1;31m Java is missing, Ensure you install it\e[0m"
  exit 2
fi

type xq &>/dev/null
if [ $? -ne 0 ]; then
  echo -e "\e[1;31m xq is missing, Ensure you install it\e[0m"
  exit 2
fi

# Download cli jar file
curl -f -s -o /tmp/cli.jar  ${URL}/jnlpJars/jenkins-cli.jar
if [ $? -ne 0 ]; then
  echo -e "\e[1;31m Unable to Download Jenkins CLI"
  exit 2
fi

curl -f -s -o /home/centos/agent.jar ${URL}/jnlpJars/agent.jar

#
java -jar /tmp/cli.jar -auth ${USERNAME}:${PASSWORD} -s ${URL} get-node ${AGENTNAME} &>/dev/null
if [ $? -eq 0 ]; then
  if [ "$5" = "--force" ]; then
    java -jar /tmp/cli.jar -auth ${USERNAME}:${PASSWORD} -s ${URL} delete-node ${AGENTNAME} &>/dev/null
  else
    echo -e "\e[1;33m Agent Already exists, Use another name\e[0m"
    exit 1
  fi
fi

# Create Agent with CLI
sed -e "s/AGENTNAME/${AGENTNAME}/" node.xml | java -jar /tmp/cli.jar -auth ${USERNAME}:${PASSWORD} -s ${URL} create-node ${AGENTNAME}

# Configure Agent with CLI
TOKEN=$(curl -s -u ${USERNAME}:${PASSWORD} ${URL}/computer/${AGENTNAME}/slave-agent.jnlp | sed -e 's|>| |g' -e 's|<| |g' | xargs -n1 | grep argument -A1 | grep -v argument  | head -1)

sed -i -e "s|URL|${URL}|" -e "s/AGENTNAME/${AGENTNAME}/" -e "s/TOKEN/${TOKEN}/" slave.service
sudo cp slave.service /etc/systemd/system/jenkins-slave.service
sudo systemctl daemon-reload
sudo systemctl enable jenkins-slave
sudo systemctl start jenkins-slave

# Setup jenkins startup script