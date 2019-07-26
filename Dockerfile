FROM jenkins/jnlp-slave:alpine

USER root

RUN apk update
RUN apk add nodejs npm
RUN npm install -g gitbook
