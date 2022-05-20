#!/bin/bash
docker pull nginx
docker stop nginx || true && docker rm nginx || true
aws secretsmanager get-secret-value --secret-id "%s" --region %s | jq -r ".SecretString" > .env
cat .env
docker run --name nginx -p 80:80 -d nginx