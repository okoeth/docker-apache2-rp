FROM ubuntu:14.04 
MAINTAINER Oliver Koeth "oliver.koeth@nttdata.com" 
RUN echo $http_proxy
RUN if [ ! -z $http_proxy ]; then echo "Acquire::http::proxy \"$http_proxy\";" >> /etc/apt/apt.conf; fi
RUN apt-get update 
RUN apt-get install -y apache2 
RUN apt-get install -y apache2-utils
RUN a2enmod rewrite
RUN a2enmod expires
RUN a2enmod headers
RUN a2enmod remoteip
RUN ln -s /etc/apache2/mods-available/proxy.load /etc/apache2/mods-enabled
RUN ln -s /etc/apache2/mods-available/proxy_http.load /etc/apache2/mods-enabled

ADD ./apache2.conf /etc/apache2/apache2.conf
ADD ./default.conf /etc/apache2/sites-available/000-default.conf
ADD ./security.conf /etc/apache2/conf-available/security.conf
ADD ./proxy.conf /etc/apache2/mods-available/proxy.conf 
ADD ./start.sh /start.sh
RUN chmod 755 /start.sh
RUN mkdir /var/lock/apache2
RUN mkdir /var/run/apache2
RUN htpasswd -cdb /var/www/.htpasswd rpuser rpuser2015
RUN echo 'Hi, I am in your container2' >/var/www/index.html

EXPOSE 80

CMD ["./start.sh"]
