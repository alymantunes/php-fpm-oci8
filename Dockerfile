FROM php:7.4-fpm
LABEL maintainer "Alym Antunes <alymabi@gmail.com>"

RUN apt-get update -y
RUN apt-get install -y \
    unzip\
    wget \
    libaio1\
    libldap2-dev 

ADD oracle /tmp/

RUN unzip /tmp/instantclient-basic-linux.x64-12.2.0.1.0.zip -d /usr/local/ && \
    unzip /tmp/instantclient-sdk-linux.x64-12.2.0.1.0.zip -d /usr/local/ && \
    unzip /tmp/instantclient-sqlplus-linux.x64-12.2.0.1.0.zip -d /usr/local/ && \
    ln -s /usr/local/instantclient_12_2 /usr/local/instantclient && \
    ln -s /usr/local/instantclient/libclntsh.so.* /usr/local/instantclient/libclntsh.so && \
    ln -s /usr/local/instantclient/lib* /usr/lib && \
    ln -s /usr/local/instantclient/sqlplus /usr/bin/sqlplus && \
    docker-php-ext-configure oci8 --with-oci8=instantclient,/usr/local/instantclient && \
    docker-php-ext-install oci8 && \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-install ldap && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*.zip

RUN wget http://php.net/distributions/php-7.4.27.tar.gz && \
    mkdir php_oci && \
    mv php-7.4.27.tar.gz ./php_oci
WORKDIR php_oci
RUN tar xfvz php-7.4.27.tar.gz
WORKDIR php-7.4.27/ext/pdo_oci
RUN phpize && \
    ./configure --with-pdo-oci=instantclient,/usr/local/instantclient,12.2 && \
    make && \
    make install && \
    echo extension=pdo_oci.so > /usr/local/etc/php/conf.d/pdo_oci.ini && \
    php -m


