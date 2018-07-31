FROM ubuntu:16.04

USER root

RUN apt-get update && apt-get install -y \
  # core setup/debug packages (not needed for running app)
  openssh-client \
  apt-transport-https \
  sudo \
  curl \
  vim \
  # base python/pip/virtualenv packages
  python3-setuptools \
  build-essential \
  python3-pip \
  python3-dev \
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
  # packages needed for building deb installer
  ruby-full

# Node 6 repo
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -

# Yarn repo
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -y \
  nodejs \
  yarn

RUN pip3 install --upgrade pip
RUN pip3 install tox unittest-xml-reporting tblib pipenv

RUN gem install fpm

RUN useradd -ms /bin/bash djuser
RUN echo "djuser:djuser" | chpasswd
RUN adduser djuser sudo

USER djuser
WORKDIR /home/djuser
