FROM node:10.12.0-alpine as builder

RUN apk update && apk upgrade && apk add --no-cache bash git openssh

COPY ./ /working_dir/

WORKDIR /working_dir/packages/A