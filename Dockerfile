# Version 0.0.1
FROM ubuntu:14.04
MAINTAINER Abraham Hernando Navas "ahernando@ahnsysadmin.com"

#configuramos la hora del sistema
RUN echo "Europe/Madrid" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

#instalamos actualizaciones
RUN apt-get update && apt-get upgrade -y

#Establecemos password de root
RUN echo "mysql-server-5.6 mysql-server/root_password password conectame" | sudo debconf-set-selections
RUN echo "mysql-server-5.6 mysql-server/root_password_again password conectame" | sudo debconf-set-selections

#Instalamos mysqlserver
RUN apt-get -y install mysql-server-5.6

#Configuramos mysql para que permita conexiones desde cualquier host
RUN sed -i 's/127\.0\.0\.1/0\.0\.0\.0/g' /etc/mysql/my.cnf

#Añadimos el script para que permita la conexion de root en remoto
ADD mysql.sql /script/mysql.sql

#Publicamos puerto mysql
EXPOSE 3306

#Lanzamos mysql
CMD  mysqld_safe --init-file=/scripts/mysql.sql
