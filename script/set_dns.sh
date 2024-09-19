#!/bin/bash

# ==================================
# set docker insecure list
# ==================================
sudo cat <<EOR > /etc/docker/daemon.json
{
    "insecure-registries" : ["$DEPLOYMENT_PLATFORM_IP", "$DEPLOYMENT_PLATFORM_IP:80"]
}
EOR

# ==================================
# edit docker.service
# ==================================
sudo sed -i '/^ExecStart =/s/^/#/' /lib/systemd/system/docker.service
sudo sed -i '/^#ExecStart =/a\ExecStart = \nExecStart =/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:35432' /lib/systemd/system/docker.service

# ==================================
# set containerd configuration
# ==================================
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml > /dev/null

# mirrors
line1= "[plugins."io.containerd.grpc.v1.cri".registry.mirrors."$DEPLOYMENT_PLATFORM_IP"]"
line2="endpoint = ["http://$DEPLOYMENT_PLATFORM_IP"]"

sudo sed -i '/^\[plugins."io.containerd.grpc.v1.cri".registry.mirrors\]/a\'"$line1"'\n'"$line2" /etc/containerd/config.toml


# configs
line3= "[plugins."io.containerd.grpc.v1.cri".registry.configs."$DEPLOYMENT_PLATFORM_IP".tls]"
line4='insecure_skip_verify = true'

sudo sed -i '/^\[plugins."io.containerd.grpc.v1.cri".registry.configs]/a\'"$line3"'\n'"$line4" /etc/containerd/config.toml

# ==================================
# edit containerd
# ==================================
mkdir -p /etc/systemd/system/containerd.service.d


cat <<EOF >/etc/systemd/system/containerd.service.d/override.conf
[Service]
ExecStart=
ExecStart=/usr/bin/containerd --config /etc/containerd/config.toml
EOF

sudo systemctl daemon-reload
sudo systemctl restart containerd
sudo systemctl restart docker