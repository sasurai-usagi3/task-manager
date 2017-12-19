FROM ubuntu:latest
MAINTAINER Takumu Uyama
ARG DATABASE_ROOT_PASSWORD=password
ARG MODE=development
RUN apt-get update && apt-get -y upgrade && apt-get -y install software-properties-common tzdata && echo "mysql-server-5.7 mysql-server/root_password password $DATABASE_ROOT_PASSWORD" | debconf-set-selections && echo "mysql-server-5.7 mysql-server/root_password_again password $DATABASE_ROOT_PASSWORD" | debconf-set-selections
RUN apt-get -y install mysql-server
COPY ./$MODE/setup-db ./
COPY ./my.cnf /etc/mysql
RUN service mysql start && mysql -u root -p$DATABASE_ROOT_PASSWORD < ./setup-db && rm ./setup-db
ENV DATABASE_ROOT_PASSWORD=$DATABASE_ROOT_PASSWORD
CMD service mysql start && tail -f /dev/null
