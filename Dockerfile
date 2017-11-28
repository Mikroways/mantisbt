FROM php:7-apache
MAINTAINER info@mikroways.net

RUN a2enmod rewrite

RUN set -xe \
    && apt-get update \
    && apt-get install -y libpng12-dev libjpeg-dev libpq-dev libxml2-dev libldap2-dev \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install gd mbstring pdo_mysql mysqli soap ldap \
    && rm -rf /var/lib/apt/lists/*

ENV MANTIS_VER 2.6.0
ENV MANTIS_MD5 e2704916382459f751abcf3dc4872e44
ENV MANTIS_URL http://jaist.dl.sourceforge.net/project/mantisbt/mantis-stable/${MANTIS_VER}/mantisbt-${MANTIS_VER}.tar.gz
ENV MANTIS_FILE mantisbt.tar.gz

RUN set -xe \
    && curl -fSL ${MANTIS_URL} -o ${MANTIS_FILE} \
    && echo "${MANTIS_MD5}  ${MANTIS_FILE}" | md5sum -c \
    && tar -xz --strip-components=1 -f ${MANTIS_FILE} \
    && rm ${MANTIS_FILE} \
    && chown -R www-data:www-data .

RUN set -xe \
    && ln -sf /usr/share/zoneinfo/America/Argentina/Buenos_Aires /etc/localtime \
    && echo 'date.timezone = "America/Argentina/Buenos_Aires"' > /usr/local/etc/php/php.ini

ADD ./mantis-entrypoint /usr/local/bin/mantis-entrypoint
ADD ./mantis-entrypoint-crontab /usr/local/bin/mantis-entrypoint-crontab

CMD ["mantis-entrypoint"]
