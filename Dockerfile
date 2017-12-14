FROM ubuntu:latest
MAINTAINER Takumu Uyama
ARG APP_NAME=rails_app
ARG MODE=development
RUN export LANG=C.UTF-8 && apt-get update && apt-get install -y software-properties-common python-software-properties && add-apt-repository -y ppa:ondrej/apache2 && apt-get update && apt-get -y upgrade && apt-get -y install software-properties-common tzdata && echo 'mysql-server-5.7 mysql-server/root_password password password' | debconf-set-selections && echo 'mysql-server-5.7 mysql-server/root_password_again password password' | debconf-set-selections
RUN apt-get -y install nodejs libcurl4-openssl-dev apache2-dev libapr1-dev libaprutil1-dev libxml2 libxslt-dev build-essential patch libssl-dev mysql-server libmysqlclient-dev apache2 git libreadline-dev
RUN cd /usr/local && git clone https://github.com/sstephenson/rbenv.git .rbenv && git clone https://github.com/sstephenson/ruby-build.git .rbenv/plugins/ruby-build
ENV RBENV_ROOT=/usr/local/.rbenv PATH="/usr/local/.rbenv/bin:$PATH"
RUN eval "$(rbenv init -)" && rbenv install 2.4.0 && rbenv global 2.4.0 && rbenv rehash && gem install rails passenger --no-document && passenger-install-apache2-module --auto && passenger-install-apache2-module --snippet >> /etc/apache2/apache2.conf
RUN echo 'export RBENV_ROOT=/usr/local/.rbenv\nexport PATH="/usr/local/.rbenv/bin:$PATH"\neval "$(rbenv init -)"' >> ~/.bashrc
RUN mkdir /var/www/html/$APP_NAME && useradd -d /home/$APP_NAME -b /bin/false $APP_NAME && mkdir /home/$APP_NAME && chown $APP_NAME:$APP_NAME /home/$APP_NAME && chmod 700 /home/$APP_NAME && mkdir /home/$APP_NAME/.ssh
COPY ./$MODE/rails-default.conf /etc/apache2/sites-available/
COPY ./my.cnf /etc/mysql
COPY id_rsa /home/$APP_NAME/.ssh
RUN chmod 600 /home/$APP_NAME/.ssh/id_rsa && chmod 700 /home/$APP_NAME/.ssh
RUN ssh-keyscan -H github.com >> /home/$APP_NAME/.ssh/known_hosts
RUN a2ensite rails-default && a2dissite 000-default && a2enmod ssl http2
RUN if [ $MODE = 'production' ]; then cd ~ && git clone https://github.com/letsencrypt/letsencrypt.git && cd letsencrypt && ./letsencrypt-auto --help && ./letsencrypt-auto certonly --webroot --webroot-path /var/www/html/todo -d scrum-log.com;fi
WORKDIR /var/www/html/$APP_NAME
CMD service apache2 start && service mysql start && tail -f /dev/null
