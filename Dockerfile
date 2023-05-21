FROM  ubuntu:23.10
LABEL maintainer="a.alnasani@outlook.com"

RUN apt update 

RUN apt install -y nginx  curl composer
RUN apt install php8.1 \
                php8.1-fpm\ 
                php8.1-mbstring\
                php8.1-xml \
                php8.1-tokenizer \
                php8.1-calendar \
                php8.1-ctype \
                php8.1-sysvsem \
                php8.1-xsl \
                php8.1-xmlwriter \
                php8.1-xmlreader \
                php8.1-sysvshm \
                php8.1-sysvsem \
                php8.1-sysvmsg \
                php8.1-sockets \
                php8.1-simplexml \
                php8.1-shmop \
                php8.1-bcmath \
                php8.1-curl \
                php8.1-zip \
                php8.1-pdo-mysql \
                php8.1-intl -y 
RUN apt update && apt upgrade -y
RUN mkdir app
WORKDIR /var/www/html

RUN rm -rf /var/www/html/index.html \
    && rm -rf /var/www/html/index.nginx-debian.html

# Download and run the install script
#RUN curl -fsSL https://ddev.com/install.sh | bash
# Optionally enable Mutagen for the best performance (recommended!)
#RUN ddev config global --mutagen-enabled

# ###### #### Craftcms
RUN composer  create-project craftcms/craft

COPY craft.conf /etc/nginx/conf.d/
RUN chown -R www-data:www-data /var/www/html/craft


RUN rm /etc/nginx/sites-available/default 
RUN rm /etc/nginx/sites-enabled/default
COPY default /etc/nginx/sites-available/
COPY default /etc/nginx/sites-enabled/
#COPY index.php /var/www/html
#RUN service nginx -t
#RUN service nginx reload \
#    service nginx restart

# add php repo
#RUN add-apt-repository ppa:ondrej/php 
#RUN apt  -y --force-yes install php8.2  

EXPOSE 80
#ENTRYPOINT [ " echo" ]
#CMD ["/bin/bash", "-c", "echo FIRST COMMAND;echo SECOND COMMAND"]
#CMD ["nginx", "-g", "daemon off;"]
CMD ["/bin/bash", "-c", "php-fpm8.1 && nginx -g 'daemon off;'"]