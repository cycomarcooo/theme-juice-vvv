#!/bin/bash
echo "LC_ALL=\"en_US.UTF-8\"" >> /etc/environment
echo "LANG=\"en_US.UTF-8\"" >> /etc/environment

apt-get install -y language-pack-en-base
locale-gen en_US.UTF-8

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
