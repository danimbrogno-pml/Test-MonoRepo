FROM node:10.12.0-alpine as builder

COPY ./ /working_dir

RUN yarn install

FROM node:10.12-0-alpine

COPY --from=builder /working_dir/dist /working_dir/dist
COPY --from=builder /working_dir/node_modules /working_dir/node_modules

RUN node dist/index.js