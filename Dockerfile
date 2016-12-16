FROM hypriot/rpi-ruby:2.2.2
FROM hypriot/rpi-node:7.0.0
# Install Java for s3_website gem
FROM hypriot/rpi-java:1.7.0-jre
MAINTAINER Clif Reeder clifreeder@gmail.com

ENV DEBIAN_FRONTEND noninteractive

RUN gem install bundler

WORKDIR /tmp
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install

COPY . /usr/src/app
WORKDIR /usr/src/app
