FROM ubuntu:latest
MAINTAINER Takumu Uyama
ARG MODE=development
RUN apt-get update && apt-get -y install git apache2
RUN if [ $MODE = 'production' ]; then cd ~ && git clone https://github.com/letsencrypt/letsencrypt.git && cd letsencrypt && (echo -e "Y\n" | ./certbot-auto -n --version);fi
CMD service apache2 start && (if [ $MODE = 'production' ]; then cd ~/letsencrypt && ./certbot-auto certonly -m 'sasurai.usagi3@gmail.com' --agree-tos --webroot -n --webroot-path /var/www/html -d smooth-work.com --force-renewal;fi) && tail -f /dev/null
