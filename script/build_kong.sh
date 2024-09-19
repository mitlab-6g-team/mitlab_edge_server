#!/bin/bash

# ==================================
# create a docker network for kong
# ==================================
echo ==================================
echo "create a docker network for kong"
echo ==================================
docker network create kong-net

# ==================================
# create a docker volume for kong
# ==================================
echo ==================================
echo "create a docker volume for kong"
echo ==================================
docker volume create kong-db-volume

# ==================================
# run postgres container
# ==================================
echo ==================================
echo "run postgres container"
echo ==================================
docker run -d --name kong-database \
	--restart=always \
    --network=kong-net \
    -p 5432:5432 \
    -e "POSTGRES_DB=kong" \
    -e "POSTGRES_USER=kong" \
    -e "POSTGRES_PASSWORD=kong" \
    -v kong-db-volume:/var/lib/postgresql/data \
    postgres:11

# ==================================
# migrate kong table to postgres
# ==================================
echo ==================================
echo "migrate kong table to postgres"
echo ==================================
docker run --rm \
    --network=kong-net \
    -e "KONG_DATABASE=postgres" \
    -e "KONG_PG_HOST=kong-database" \
    -e "KONG_PG_DATABASE=kong" \
    -e "KONG_PG_USER=kong" \
    -e "KONG_PG_PASSWORD=kong" \
    kong:3.4 kong migrations bootstrap

# ==================================
# run kong container
# ==================================
echo ==================================
echo "run kong container"
echo ==================================
docker run -d --name kong \
	--restart=always \
    --network=kong-net \
    -e "KONG_DATABASE=postgres" \
    -e "KONG_PG_HOST=kong-database" \
    -e "KONG_PG_DATABASE=kong" \
    -e "KONG_PG_USER=kong" \
    -e "KONG_PG_PASSWORD=kong" \
    -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
    -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
    -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
    -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
    -e "KONG_ADMIN_LISTEN=0.0.0.0:8001" \
    -p 8000:8000 \
    -p 8443:8443 \
    -p 8001:8001 \
    -p 8444:8444 \
    kong:3.4