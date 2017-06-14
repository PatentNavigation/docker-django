FROM ubuntu:16.04

USER root

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  build-essential \
  python-setuptools \
  python-virtualenv \
  python-dev \
  python-pip \
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
