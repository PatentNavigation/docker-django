FROM ubuntu:16.04

USER root

RUN apt-get update && apt-get install -y \
  apt-transport-https \
  sudo \
  curl \
  vim \
  openssh-client \
  git-core \
  build-essential \
  python-setuptools \
  python-virtualenv \
  python-dev \
  python-pip \
  ruby-full \
  rsyslog \
  libssl-dev \
  ghostscript \
  pdftk \
  libffi-dev \
  libxml2-dev \
  libxslt1-dev \
  python-mysqldb \
  mysql-client \
  libmysqlclient-dev

# Node 6 repo
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -

# Yarn repo
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -y \
  nodejs \
  yarn

RUN pip install --upgrade pip
RUN pip install tox unittest-xml-reporting tblib

RUN gem install fpm

ADD sql_mode.cnf /etc/mysql/conf.d/sql_mode.cnf

RUN useradd -ms /bin/bash djuser
RUN echo "djuser:djuser" | chpasswd
RUN adduser djuser sudo

USER djuser
WORKDIR /home/djuser
