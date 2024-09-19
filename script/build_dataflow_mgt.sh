#!/bin/bash

cd ./dataflow_mgt

# ==================================
# init the submodule
# ==================================
git submodule update --init --recursive

# ==================================
# set the env params
# ==================================
cp .env.sample .env
cp ../.env.common .env.common

# ==================================
# build image and run container
# ==================================
docker build -t dataflow:latest .
docker run -d --name my_dataflow --restart=always -p 30308:30308 dataflow:latest