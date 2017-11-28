# FROM ubuntu:16.04

# Pull base image
FROM openjdk:8u151

# Env variables
ENV SCALA_VERSION 2.12.1
ENV SBT_VERSION 0.13.12
ENV BASE_FRAMEWORK_CODE 2.5.x

# Scala expects this file
RUN touch /usr/lib/jvm/java-8-openjdk-amd64/release

# Install Scala
## Piping curl directly in tar
RUN \
  curl -fsL https://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /root/ && \
  echo >> /root/.bashrc && \
  echo "export PATH=~/scala-$SCALA_VERSION/bin:$PATH" >> /root/.bashrc

# Install sbt
RUN \
  curl -L -o sbt-$SBT_VERSION.deb https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install sbt && \
  rm -rf /var/lib/apt/lists/* && \
  sbt sbtVersion

# Define working directory
WORKDIR /root

# Install dependencies for base framework
RUN git clone https://github.com/playframework/play-java-starter-example.git &&\
    cd play-java-starter-example &&\
    git checkout $BASE_FRAMEWORK_CODE &&\
    sbt dist &&\
    rm -rf /root/play-java-starter-example