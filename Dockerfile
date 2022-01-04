FROM almalinux:8.5
MAINTAINER ajeeth.samuel@gmail.com

# install httpd
RUN yum -y install httpd vim-enhanced bash-completion unzip

# install mysql
RUN yum install -y mysql 
RUN echo "NETWORKING=yes" > /etc/sysconfig/network

# install php
RUN yum install -y php php-cli php-soap php-zip php-json php-odbc php-pear php-common php-pdo php-mbstring php-ldap php-soap php-opcache php-intl php-gd php-xmlrpc php-xml graphviz python-pip

# install supervisord
RUN pip install supervisor

ADD httpd2.conf /etc/httpd/conf/httpd.conf
ADD phpinfo.php /var/www/html/
ADD supervisord.conf /etc/
EXPOSE 22 80 443

CMD ["supervisord", "-n"]
