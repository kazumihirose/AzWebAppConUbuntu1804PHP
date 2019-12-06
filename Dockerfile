FROM ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -y sudo supervisor
# timezone setting
ENV TZ=Asia/Tokyo 
RUN apt-get install -y tzdata
RUN apt-get install -y tzdata
RUN sudo apt-get install -y  git  wget curl build-essential
RUN sudo apt-get install -y  nginx nginx-common nginx-core
RUN sudo apt-get install -y  php-fpm php-dev php7.2-fpm php7.2-cgi php7.2-cli php7.2-common php7.2-curl php7.2-dev php7.2-gd php7.2-intl php7.2-json php7.2-mbstring php7.2-mysql php7.2-opcache php7.2-readline php7.2-xml php7.2-xmlrpc php7.2-zip
#RUN /bin/bash ubuntudonew.sh
# ssh
ENV SSH_PASSWD "root:Docker!"
RUN apt-get update \
        && apt-get install -y --no-install-recommends dialog \
        && apt-get update \
	&& apt-get install -y --no-install-recommends openssh-server \
	&& echo "$SSH_PASSWD" | chpasswd 

# supervisord
COPY supervisord.conf /etc/supervisor/
COPY sshd.conf /etc/supervisor/conf.d/
COPY nginx.conf /etc/supervisor/conf.d/
COPY php-fpm.conf /etc/supervisor/conf.d/

# sshd
COPY sshd_config /etc/ssh/
RUN mkdir /run/sshd

# nginx
COPY default /etc/nginx/sites-available/

# php-fpm
RUN mkdir /run/php

# other contents
COPY index.php /var/www/html/

# Port setting
EXPOSE 8000 2222

# CMD
CMD ["/usr/bin/supervisord", "-n"]
