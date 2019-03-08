#
# Ubuntu Dockerfile
#
# https://github.com/dockerfile/ubuntu
#

# Pull base image.
FROM ubuntu:latest

# Install.
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y gnupg2 && \
  apt-get --assume-yes -y install sudo && \
  apt-get --assume-yes install curl && \
  curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash - && \
  apt-get --assume-yes install -y nodejs=10.15.3-1nodesource1 && \
  sudo apt-get install --assume-yes openjdk-8-jdk=8u191-b12-2ubuntu0.18.04.1 && \
  sudo npm install -g react-native-cli@2.0.1 && \
  sudo mkdir /root/project

RUN apt-get --assume-yes install wget && \
    apt-get --assume-yes install unzip


# Add files.
# ADD root/.gitconfig /root/.gitconfig
# ADD root/.scripts /root/.scripts

# Define working directory.
WORKDIR /root

RUN wget "https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip"
RUN unzip sdk-tools-linux-4333796.zip -d android-sdk
RUN rm -rf sdk-tools-linux-4333796.zip

WORKDIR /root/android-sdk/tools/bin

RUN yes | ./sdkmanager "platform-tools" "platforms;android-28"
RUN yes | ./sdkmanager "build-tools;28.0.3"

# Set environment variables.
ENV HOME /root

ENV ANDROID_HOME="${HOME}/android-sdk"

ENV PATH="${ANDROID_HOME}/emulator:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:/usr/lib/jvm/java-8-openjdk-amd64/bin:${PATH}"

WORKDIR /root

# Define default command.
CMD ["/bin/bash"]