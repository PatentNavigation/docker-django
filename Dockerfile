FROM ubuntu:16.04

USER root

# python3.7 backports repo
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 6A755776
RUN echo 'deb http://ppa.launchpad.net/deadsnakes/ppa/ubuntu xenial main' > /etc/apt/sources.list.d/deadsnakes-ubuntu-ppa-xenial.list

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
  # core setup/debug packages (not needed for running app)
  openssh-client \
  apt-transport-https \
  sudo \
  curl \
  vim \
  # python & packages needed to install pip dependencies
  python3.7-dev \
  python3-pip \
  build-essential \
  git-core \
  libffi-dev \
  libxml2-dev \
  libxslt1-dev \
  # DB-related packages
  mysql-client-core-5.7 \
  mysql-server-5.7 \
  libmysqlclient-dev \
  # farnsworth-specific packages
  libssl-dev \
  libjpeg-dev \
  # dev packages
  nano

RUN rm /usr/bin/python3 && ln -s /usr/bin/python3.7 /usr/bin/python3

# Node 12 repo
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

# Yarn repo
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update && apt-get install -y \
  nodejs \
  yarn

# pipenv
RUN pip3 install pipenv

RUN /etc/init.d/mysql start && sleep 5 && \
     mysql -uroot -e "create user 'farnsworth'@'localhost' identified by 'farnsworth'" && \
     mysql -uroot -e "create database farnsworth DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci" && \
     mysql -uroot -e "grant all privileges on *.* to 'farnsworth'@'localhost' with grant option"

RUN echo "[mysqld]" >> /etc/my.cnf && \
    echo "sql_mode=STRICT_TRANS_TABLES" >> /etc/my.cnf

RUN  /etc/init.d/mysql start

RUN useradd -ms /bin/bash djuser
RUN echo "djuser:djuser" | chpasswd
RUN adduser djuser sudo
RUN echo "djuser  ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/djuser

USER djuser
WORKDIR /home/djuser

RUN echo 'export LANG="en_US.UTF-8"' >> .bash_profile
RUN echo 'export LC_ALL="en_US.UTF-8"' >> .bash_profile
RUN echo 'export LC_CTYPE="en_US.UTF-8"' >> .bash_profile

COPY --chown=djuser:djuser .ssh/id_ed25519* .ssh/
RUN eval `ssh-agent -s` && ssh-add .ssh/id_ed25519
RUN ssh-keyscan -t rsa github.com >> .ssh/known_hosts

WORKDIR /repos
RUN git clone git@github.com:PatentNavigation/farnsworth.git

# WORKDIR /repos/farnsworth
# RUN  yarn
# RUN  yarn bower
# RUN  pipenv lock
# RUN  pipenv sync --dev
# RUN  pipenv run ./manage.py migrate
# RUN  pipenv run ./manage.py createorganization --name=TurboPatent --domain=tp
# RUN  pipenv run ./manage.py waffle
# RUN  pipenv run ./manage.py loaddata std_clients
