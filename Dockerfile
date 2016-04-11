FROM alpine:latest
MAINTAINER weiteng huang <weiteng.huang@gmail.com>

RUN apk add --update \
  python \
  make
RUN apk add --update -t nodejs && npm install -g npm@latest

ENV NODE_ENV="development"
ENV APPLICATION_NAME="playground"

ENV APP_HOST="localhost"
ENV APP_PORT=3000

ENV RETHINK_HOST="rethink"
ENV RETHINK_PORT=28015
ENV RETHINK_CLUSTER_PORT=29015
ENV RETHINK_DB="playground"

ENV NSQD_ADDR="nsqd:4151"

RUN mkdir -p /opt/playground
WORKDIR /opt/playground
COPY ./src /opt/playground/src
ADD ./.eslintrc.yml /opt/playground/.eslintrc.yml
ADD ./package.json /opt/playground/package.json

COPY docker-entrypoint.sh /opt/playground/docker-entrypoint.sh
ENTRYPOINT ["/opt/playground/docker-entrypoint.sh"]

EXPOSE $APP_PORT

CMD ["/usr/bin/npm", "start"]
