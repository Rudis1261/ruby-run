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
RUN rm /bin/ls
RUN rm /bin/cp
RUN rm /bin/mv
RUN rm /bin/dd
RUN rm /bin/cat
RUN rm /bin/grep
RUN rm /bin/gzip
RUN rm /bin/gunzip
RUN rm /bin/mkdir
RUN rm /bin/touch
RUN rm /bin/ln
RUN rm /bin/rmdir
RUN rm /bin/stat
RUN rm /bin/sed
RUN rm /bin/tar
RUN rm /bin/watch
RUN rm /bin/uname
RUN rm /bin/sleep

RUN rm /usr/bin/passwd

RUN rm /bin/rm

WORKDIR /home/app
