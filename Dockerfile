FROM ruby:2.3-alpine
MAINTAINER Rudi Strydom <iam@thatguy.co.za>

RUN gem install rdoc-data
RUN rdoc-data --install

RUN mkdir -p /home/app

WORKDIR /home/app
