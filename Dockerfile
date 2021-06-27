FROM ubuntu:focal
SHELL ["/bin/bash", "-c"]

RUN apt update && apt install -y curl apt-transport-https ca-certificates

RUN echo 'tzdata tzdata/Areas select Europe' | debconf-set-selections
RUN echo 'tzdata tzdata/Zones/Europe select London' | debconf-set-selections
RUN DEBIAN_FRONTEND="noninteractive" apt install -y tzdata
RUN apt update && apt install -y openjdk-8-jdk wget git gnupg-agent software-properties-common docker-compose docker curl

#Install dot net
RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update
RUN apt-get install -y dotnet-sdk-5.0

# Install Jenkins slave in swarm mode
ENV JENKINS_SWARM_VERSION 3.26
ENV HOME /home/jenkins-slave

# install netstat to allow connection health check with
# netstat -tan | grep ESTABLISHED
RUN apt-get update && apt-get install -y net-tools && rm -rf /var/lib/apt/lists/*

RUN useradd -c "Jenkins Slave user" -d $HOME -m jenkins-slave
RUN usermod -a -G docker jenkins-slave
RUN curl --create-dirs -sSLo /usr/share/jenkins/swarm-client-$JENKINS_SWARM_VERSION.jar https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/$JENKINS_SWARM_VERSION/swarm-client-$JENKINS_SWARM_VERSION.jar \
  && chmod 755 /usr/share/jenkins

COPY jenkins-slave.sh /usr/local/bin/jenkins-slave.sh

USER jenkins-slave
VOLUME /home/jenkins-slave

ENTRYPOINT ["/usr/local/bin/jenkins-slave.sh"]



# FROM openjdk:8-jdk

# RUN apt-get update && apt-get install -y wget git apt-transport-https ca-certificates curl gnupg-agent software-properties-common

# #Install dot net
# RUN wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
# RUN dpkg -i packages-microsoft-prod.deb
# RUN apt-get update
# RUN apt-get install -y dotnet-sdk-5.0

# # RUN wget -O - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg
# # RUN mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
# # RUN wget https://packages.microsoft.com/config/debian/9/prod.list
# # RUN mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
# # RUN chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
# # RUN chown root:root /etc/apt/sources.list.d/microsoft-prod.list
# # RUN  apt-get update
# # RUN  apt-get install -y dotnet-sdk-5.0

# # Install docker compose
# RUN curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# RUN chmod +x /usr/local/bin/docker-compose

# # Install Docker
# RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
# RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
# RUN apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io

# # Install Jenkins slave in swarm mode
# ENV JENKINS_SWARM_VERSION 3.26
# ENV HOME /home/jenkins-slave

# # install netstat to allow connection health check with
# # netstat -tan | grep ESTABLISHED
# RUN apt-get update && apt-get install -y net-tools && rm -rf /var/lib/apt/lists/*

# RUN useradd -c "Jenkins Slave user" -d $HOME -m jenkins-slave
# RUN usermod -a -G docker jenkins-slave
# RUN curl --create-dirs -sSLo /usr/share/jenkins/swarm-client-$JENKINS_SWARM_VERSION.jar https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/$JENKINS_SWARM_VERSION/swarm-client-$JENKINS_SWARM_VERSION.jar \
#   && chmod 755 /usr/share/jenkins

# COPY jenkins-slave.sh /usr/local/bin/jenkins-slave.sh

# USER jenkins-slave
# VOLUME /home/jenkins-slave

# ENTRYPOINT ["/usr/local/bin/jenkins-slave.sh"]