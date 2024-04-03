# PHP Composer - Continuous Integration on Docker

The image has been created to run unit tests on a php application inside a docker container

# Running examples
To run the image you need to add the application to a volume and run the docker image with the following command

```
docker run -it --rm -v project-route:/data -w /data izertis/php-composer-ci:8.1 bash
```

Inside the container add the necessary dependencies in the composer and install

```
composer require phpunit/phpunit "^9.6" --dev --no-update && composer install;
```

# Drupal
To run unit tests in a Drupal application you have to execute the following commands

```
mkdir -p web/sites/simpletest/browser_output
chmod 777 -R web/sites/simpletest
```

To test the custom modules, execute the following command
```
php -d xdebug.mode=coverage vendor/bin/phpunit web/modules/custom/ --coverage-clover coverage.xml -v
```