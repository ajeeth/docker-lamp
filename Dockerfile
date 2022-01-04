FROM almalinux:8-minimal
MAINTAINER ajeeth.samuel@gmail.com

# install httpd
RUN yum -y install httpd vim-enhanced bash-completion unzip

# yum patch
RUN (yum install -y yum-plugin-ovl || yum install -y yum-plugin-ovl)

# install mysql
RUN yum install -y mysql 
RUN echo "NETWORKING=yes" > /etc/sysconfig/network

# install php
RUN yum install -y php php-mysql php-imap php-cli php-soap php-mcrypt php-ncurses php-zip php-json php-odbc php-pear php-common php-pdo php-mbstring php-ldap php-soap php-opcache php-intl php-gd php-pecl-memcache php-pecl-Fileinfo php-pspell php-xmlrpc php-xml graphviz

# install supervisord
RUN yum install -y python-pip && pip install "pip>=1.4,<1.5" --upgrade
RUN pip install supervisor

ADD httpd2.conf /etc/httpd/conf/httpd.conf
ADD phpinfo.php /var/www/html/
ADD supervisord.conf /etc/
EXPOSE 22 80 443

CMD ["supervisord", "-n"]
