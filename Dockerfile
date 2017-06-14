FROM ubuntu:16.04

USER root

# Yarn repo
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  build-essential \
  python-setuptools \
  python-virtualenv \
  python-dev \
  python-pip \
  yarn \
  git-core \
  libffi-dev \
  libxml2-dev \
  libxslt1-dev \
  python-mysqldb \
  mysql-client \
  libmysqlclient-dev

RUN pip install --upgrade pip
RUN pip install tox

USER farnsworth
