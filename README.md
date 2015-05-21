# Heroku PHP Docker Image

Run a Heroku PHP app in a Docker container.

*Currently only supports `nginx` and `php-fpm`.*

    $> docker run -it --rm mbfisher/heroku-php -v $PWD:/app/src -p 3000:3000 foreman

# Why?

Heroku is already working on [https://devcenter.heroku.com/articles/introduction-local-development-with-docker](local dev using Docker containers)
however they currently only support Ruby and Node.js. This image was developed from their
`heroku/cedar` base image but implements the environment in a different way.

The PHP buildpack `compile` script installs system and application dependencies before starting a
foreman process, which means it's not quick. The script requires the application be present so that
it can examine `composer.json` to determine PHP vs HHVM etc. which means you can't bake the compliation
into a Docker image. This approach would require you to `COPY` your application source into the image
and rebuild everytime you make changes!

This image doesn't use the `compile` script directly, but pulls the same system dependencies from S3
and copies the same default configs from the repo for dev-prod parity. It uses a Docker volume to
mount application source into the container so that changes occur in real time.
