FROM postgres

ADD https://github.com/jwilder/dockerize/releases/download/v0.7.0/dockerize-alpine-linux-amd64-v0.7.0.tar.gz dockerize.tar.gz

RUN tar -xzf dockerize.tar.gz

RUN chmod +x dockerize

COPY ./database/init.sql /docker-entrypoint-initdb.d/

EXPOSE 5432
