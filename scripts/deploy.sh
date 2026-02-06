#!/bin/bash
set -e

ACTIVE=$(grep server nginx-proxy/nginx.conf | grep -o 'app_[a-z]*')
if [ "$ACTIVE" = "app_blue" ]; then
  NEW="green"
  OLD="blue"
else
  NEW="blue"
  OLD="green"
fi

echo "Active: $OLD → Deploying: $NEW"

docker-compose build \
  --build-arg APP_COLOR=$NEW \
  --build-arg APP_VERSION=$(date +%Y%m%d%H%M) \
  --build-arg APP_COMMIT=$(git rev-parse --short HEAD) \
  app_$NEW

docker-compose up -d app_$NEW

echo "Waiting for healthcheck..."
for i in {1..10}; do
  STATUS=$(docker inspect --format='{{.State.Health.Status}}' app_$NEW)
  if [ "$STATUS" = "healthy" ]; then
    echo "Green is healthy"
    break
  fi
  sleep 5
done

if [ "$STATUS" != "healthy" ]; then
  echo "Deployment failed → rollback"
  docker-compose rm -sf app_$NEW
  exit 1
fi

echo "Switching traffic to $NEW"
sed -i "s/app_$OLD/app_$NEW/" nginx-proxy/nginx.conf
docker-compose up -d nginx

echo "Stopping old container"
docker-compose rm -sf app_$OLD
