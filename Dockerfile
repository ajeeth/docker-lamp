FROM centos:7
MAINTAINER ajeeth.samuel@gmail.com

# install http
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# install httpd
RUN yum -y install httpd vim-enhanced bash-completion unzip

# yum patch
RUN (yum install -y yum-plugin-ovl || yum install -y yum-plugin-ovl)

# install mysql
RUN yum install -y mysql mysql-server
RUN echo "NETWORKING=yes" > /etc/sysconfig/network
# start mysqld to create initial tables
#RUN service mysqld start

# install php
RUN yum install -y php php-mysql php-imap php-cli php-mcrypt php-ncurses php-odbc php-pear php-common php-pdo php-mbstring php-ldap php-devel php-gd php-pecl-memcache php-pecl-Fileinfo php-pspell php-snmp php-xmlrpc php-xml

# install supervisord
RUN yum install -y python-pip && pip install "pip>=1.4,<1.5" --upgrade
RUN pip install supervisor

# install sshd
RUN yum install -y openssh-server openssh-clients passwd

RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key 
RUN sed -ri 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config && echo 'root:changeme' | chpasswd

# Put your own public key at id_rsa.pub for key-based login.
RUN mkdir -p /root/.ssh && touch /root/.ssh/authorized_keys && chmod 700 /root/.ssh
#ADD id_rsa.pub /root/.ssh/authorized_keys

#Add PphMyAdmin
RUN curl https://files.phpmyadmin.net/phpMyAdmin/4.9.1/phpMyAdmin-4.9.1-english.tar.gz --output /var/www/html/phpMyAdmin-4.9.1-english.tar.gz && \
cd /var/www/html/ && tar -zxf phpMyAdmin-4.9.1-english.tar.gz && mv phpMyAdmin-4.9.1-english pma && chown -R apache. pma && rm -f phpMyAdmin-4.9.1-english.tar.gz

ADD httpd2.conf /etc/httpd/conf/httpd.conf
ADD phpinfo.php /var/www/html/
ADD supervisord.conf /etc/
EXPOSE 22 80 443

CMD ["supervisord", "-n"]
