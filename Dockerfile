FROM node:18.17.1-alpine

WORKDIR /app

COPY package.json /app/
COPY yarn.lock /app/

RUN yarn install --production && yarn cache clean

RUN adduser -D localtunnel
USER localtunnel

COPY . /app

EXPOSE 8080
ENTRYPOINT ["node", "-r", "esm", "./bin/server"]
