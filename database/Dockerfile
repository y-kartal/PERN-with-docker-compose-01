FROM postgres

RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/jwilder/dockerize/releases/download/v0.7.0/dockerize-alpine-linux-amd64-v0.7.0.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-v0.7.0.tar.gz \
    && rm dockerize-alpine-linux-amd64-v0.7.0.tar.gz

COPY ./database/init.sql /docker-entrypoint-initdb.d/

EXPOSE 5432
