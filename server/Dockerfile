FROM node:14.21-slim

RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/jwilder/dockerize/releases/download/v0.7.0/dockerize-alpine-linux-amd64-v0.7.0.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-v0.7.0.tar.gz \
    && rm dockerize-alpine-linux-amd64-v0.7.0.tar.gz

WORKDIR /usr/src/app

COPY ./server/package*.json ./

RUN npm install

ADD https://github.com/jwilder/dockerize/releases/download/v0.7.0/dockerize-alpine-linux-amd64-v0.7.0.tar.gz dockerize.tar.gz

RUN tar -xzf dockerize.tar.gz

RUN chmod +x dockerize

COPY ./server/ .

EXPOSE 5000

ENTRYPOINT ["node","app.js"]
