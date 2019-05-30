FROM node:10.12.0-alpine as builder

ARG NPM_TOKEN
ARG PACKAGE_VERSION

RUN echo "//registry.npmjs.org/:_authToken=$NPM_TOKEN" > ~/.npmrc && \
  yarn global add @freightbpi/testing-b@$PACKAGE_VERSION

FROM node:10.12.0-alpine

COPY --from=builder /usr/local/share/.config/yarn/global/. /app/

WORKDIR /app/node_modules/@freightbpi/testing-b/

ENTRYPOINT ["npm"]
CMD ["start"]