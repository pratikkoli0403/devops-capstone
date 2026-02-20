FROM nginx:alpine

ARG APP_COLOR
ARG APP_VERSION
ARG APP_COMMIT

COPY app/index.html /usr/share/nginx/html/index.html

RUN sed -i "s/APP_COLOR/${APP_COLOR}/g" /usr/share/nginx/html/index.html && \
    sed -i "s/APP_VERSION/${APP_VERSION}/g" /usr/share/nginx/html/index.html && \
    sed -i "s/APP_COMMIT/${APP_COMMIT}/g" /usr/share/nginx/html/index.html

EXPOSE 80

HEALTHCHECK --interval=10s --timeout=3s \
  CMD wget -q -O - http://localhost || exit 1
