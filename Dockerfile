FROM ubuntu:16.04

USER root

# python3.7 backports repo
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 6A755776
RUN echo 'deb http://ppa.launchpad.net/deadsnakes/ppa/ubuntu xenial main' > /etc/apt/sources.list.d/deadsnakes-ubuntu-ppa-xenial.list

RUN apt-get update && apt-get install -y \
  # core setup/debug packages (not needed for running app)
  openssh-client \
  apt-transport-https \
  sudo \
  curl \
  vim \
  # python & packages needed to install pip dependencies
  python3.7-dev \
  build-essential \
  git-core \
  libffi-dev \
  libxml2-dev \
  libxslt1-dev \
  # DB-related packages
  mysql-client \
  libmysqlclient-dev \
  # farnsworth-specific packages
  libssl-dev \
  ghostscript \
  pdftk \
  # packages needed for testing
  imagemagick \
  # packages needed for building/publishing deb installer
  ruby-full

# Node 6 repo
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -

# Yarn repo
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -y \
  nodejs \
  yarn

# pipenv
RUN curl https://raw.githubusercontent.com/kennethreitz/pipenv/master/get-pipenv.py | python3.7

# build/publish deb installer
RUN gem install fpm deb-s3

RUN useradd -ms /bin/bash djuser
RUN echo "djuser:djuser" | chpasswd
RUN adduser djuser sudo

USER djuser
WORKDIR /home/djuser
