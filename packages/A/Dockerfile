FROM node:10.12.0-alpine as builder

RUN apk update && apk upgrade && apk add --no-cache bash git openssh

COPY ./ /working_dir/packages/A

WORKDIR /working_dir/packages/A

RUN yarn install

FROM node:10.12.0-alpine

COPY --from=builder /working_dir/packages/A/dist /working_dir/dist

COPY --from=builder /working_dir/packages/A/node_modules /working_dir/node_modules

CMD /bin/sh