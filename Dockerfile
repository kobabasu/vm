FROM ubuntu:14.04
MAINTAINER Keiji Kobayashi "keiji@seeknetusa.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update
# RUN apt-get -y upgrade

RUN apt-get install -y vim wget

# apache2
RUN apt-get install -y apache2

# php5
RUN apt-get install -y  \
  php5                  \
  php5-cli              \
  php5-common           \
  php5-curl             \
  php5-gd               \
  php5-gmp              \
  php5-json             \
  php5-mysql            \
  php5-sqlite           \
  php5-imagick          \
  php5-mcrypt           \
  php5-xdebug

# mysql
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN apt-get install -y -o Dpkg::Options::="--force-confold" mysql-common
RUN apt-get install -q -y mysql-server
ADD mysql/my.cnf /etc/mysql/my.cnf
RUN chmod 664 /etc/mysql/my.cnf

# port
EXPOSE 22 80 3306

# file copy test
ADD apache2/conf-available/security.conf /etc/apache2/conf-available/security.conf
ADD apache2/mods-available/dir.conf /etc/apache2/mods-available/dir.conf
ADD apache2/mods-available/mime.conf /etc/apache2/mods-available/mime.conf
ADD apache2/mods-available/negotiation.conf /etc/apache2/mods-available/negotiation.conf
ADD apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf
ADD php5/php.ini /etc/php5/apache2/php.ini

# setup
ADD setup ./setup
RUN chmod +x ./setup
RUN ./setup
# RUN /usr/bin/mysqld_safe & \
#     sleep 10s && \
#     source ./setup

# run
ADD run /usr/local/bin/run
RUN chmod +x /usr/local/bin/run
CMD ["/usr/local/bin/run"]
