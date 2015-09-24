FROM ruby:2.1.3
MAINTAINER Clif Reeder clifreeder@gmail.com

# Install Java for s3_website gem
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -y                             && \
    apt-get install -y default-jre nodejs

RUN gem install bundler

WORKDIR /tmp
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install

COPY . /usr/src/app
WORKDIR /usr/src/app
