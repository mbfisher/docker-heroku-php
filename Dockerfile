FROM heroku/cedar:14

RUN apt-get update
RUN apt-get install -y \
    libreadline5 \
    libssl0.9.8

RUN useradd -d /app -m app
USER app
WORKDIR /app

ENV HOME /app
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/app/.heroku/php/bin:/app/.heroku/php/sbin:/app/.heroku/ruby/gems/bin
ENV GEM_HOME /app/.heroku/ruby/gems
ENV PORT 3000

RUN git clone https://github.com/heroku/heroku-buildpack-php /tmp/buildpack
RUN mkdir -p /app/.heroku/php

RUN curl -Ss https://lang-php.s3.amazonaws.com/dist-cedar-master/php-5.6.9.tar.gz | tar xz -C /app/.heroku/php
RUN mkdir -p /app/.heroku/php/etc/php/conf.d
RUN cp /tmp/buildpack/conf/php/php.ini /app/.heroku/php/etc/php
RUN cp /tmp/buildpack/conf/php/php-fpm.conf /app/.heroku/php/etc/php

RUN curl -Ss https://lang-php.s3.amazonaws.com/dist-cedar-master/nginx-1.6.0.tar.gz | tar xz -C /app/.heroku/php
RUN cp /tmp/buildpack/conf/nginx/nginx.conf.default /app/.heroku/php/etc/nginx/nginx.conf

# Don't use the buildpack composer script because it blats /app/* (?!)
RUN curl -Ss https://getcomposer.org/installer | php -- --install-dir=/app/.heroku/php/bin --filename=composer && \
    chmod +x /app/.heroku/php/bin/composer

RUN gem install --no-rdoc --no-ri foreman

VOLUME /app/src
WORKDIR /app/src
