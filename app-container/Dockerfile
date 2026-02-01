FROM nginx:alpine

COPY app/index.html /usr/share/nginx/html/index.html

EXPOSE 80

HEALTHCHECK --interval=10s --timeout=3s \
  CMD wget -q -O - http://localhost || exit 1

CMD ["nginx", "-g", "daemon off;"]

