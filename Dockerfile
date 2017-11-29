# Pull base image
FROM openjdk:8u151

# Env variables
ENV SCALA_VERSION 2.12.1
ENV SBT_VERSION 0.13.12

RUN groupadd -g 1000 ubuntu && \
useradd -u 1000 -g 1000 -m -s /bin/bash ubuntu

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
  rm -rf /var/lib/apt/lists/*
  
# Run following commands as Ubuntu user
USER ubuntu:ubuntu
ENV HOME /home/ubuntu

# Define working directory
WORKDIR /home/ubuntu

# Install dependencies for base framework
RUN \
    sbt sbtVersion && \
    git clone https://github.com/uktrade/lite-image-builder.git && \
    cd lite-image-builder && \
    sbt dist && \
    cd .. && \
    rm -rf lite-image-builder