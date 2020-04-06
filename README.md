# Jenkins swarm slave ready for Dot Net Core Builds

Based of (all the hard work was done here in csanchez repo):
[`csanchez/jenkins-swarm-slave`](https://registry.hub.docker.com/u/csanchez/jenkins-swarm-slave/)

A [Jenkins swarm](https://wiki.jenkins-ci.org/display/JENKINS/Swarm+Plugin) slave.

A basic slave for building dot net core applications on.

## Running

To run a Docker container passing [any parameters](https://wiki.jenkins-ci.org/display/JENKINS/Swarm+Plugin#SwarmPlugin-AvailableOptions) to the slave

    docker run wonderphil/jenkins-swarm-slave-dotnet-core-docker -master http://jenkins:8080 -username jenkins -password jenkins -executors 1

Linking to the Jenkins master container there is no need to use `--master`

    docker run -d --name jenkins -p 8080:8080 wonderphil/jenkins-swarm
    docker run -d --link jenkins:jenkins wonderphil/jenkins-swarm-slave-dotnet-core-docker -username jenkins -password jenkins -executors 1


# Building

    docker build -t wonderphil/jenkins-swarm-slave-dotnet-core-docker .
