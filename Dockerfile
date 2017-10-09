FROM ruby:2.3-alpine
MAINTAINER Rudi Strydom <iam@thatguy.co.za>

RUN gem install rdoc-data
RUN rdoc-data --install

RUN mkdir -p /home/app

# Removing some things - people won't need these
RUN rm /sbin/apk
RUN rm /sbin/fdisk
RUN rm /sbin/reboot
RUN rm /sbin/halt

RUN rm /bin/mount
RUN rm /bin/chmod
RUN rm /bin/chown
RUN rm /bin/ps
RUN rm /bin/kill
RUN rm /bin/pwd
RUN rm /usr/bin/passwd

RUN rm /bin/rm

WORKDIR /home/app
