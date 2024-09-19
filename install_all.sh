#!/bin/bash

# ==================================
# basic dependencies
# ==================================
echo ==================================
echo basic dependencies
echo ==================================
sudo apt-get update
sudo apt update

sudo apt install curl tmux htop net-tools tree ca-certificates git vim openssh-server openssh-client -y
sudo apt-get install python3.8 python3.8-dev python3.8-distutils python3.8-venv libpython3.8-dev libpq-dev python3-pip -y

apt-cache madison docker.io
sudo apt-get install docker.io=20.10.21-0ubuntu1~20.04.2 -y
sudo chmod 777 /var/run/docker.sock
sudo groupadd docker
sudo usermod -aG docker $USER
cp .env.common.sample .env.common

# ==================================
# build inference_gatetway
# ==================================
echo ==================================
echo build inference_gatetway
echo ==================================
bash ./script/build_dataflow_mgt.sh
bash ./script/build_kong.sh

# ==================================
# build inference_host_manager
# ==================================
echo ==================================
echo build inference_host_manager
echo ==================================
bash ./script/build_k8s.sh