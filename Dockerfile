
FROM php:8.1-apache-buster

# install the PHP extensions we need
RUN set -eux; \
	\
	if command -v a2enmod; then \
	a2enmod rewrite; \
	fi; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
	libfreetype6-dev \
	libjpeg-dev \
	libpng-dev \
	libpq-dev \
	libwebp-dev \
	libzip-dev \
	git \
	nano \
	curl \
	wget \
	unzip \
	; \
	\
	docker-php-ext-configure gd \
	--with-freetype \
	--with-jpeg=/usr \
	--with-webp \
	; \
	\
	docker-php-ext-install -j "$(nproc)" \
	gd \
	opcache \
	pdo_mysql \
	pdo_pgsql \
	zip;\
	{ \
	echo 'opcache.memory_consumption=128'; \
	echo 'opcache.interned_strings_buffer=8'; \
	echo 'opcache.max_accelerated_files=4000'; \
	echo 'opcache.revalidate_freq=60'; \
	echo 'opcache.fast_shutdown=1'; \
	echo 'memory_limit=256M'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini; \
	curl -sL https://deb.nodesource.com/setup_20.x | /bin/bash -; \
	apt-get install nodejs -y; \
	pecl install -f xdebug && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini; \
	wget -O drush.phar https://github.com/drush-ops/drush-launcher/releases/download/0.4.2/drush.phar && \
	chmod +x drush.phar && \
	mv drush.phar /usr/local/bin/drush;

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/

WORKDIR /var/www/html
