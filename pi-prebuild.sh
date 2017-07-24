#!/bin/bash

set -e

echo "Hello!"
uname -a

export DEBIAN_FRONTEND=noninteractive
export APT_LISTCHANGES_FRONTEND=none

echo "Adding backports"
echo "deb [trusted=yes] http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list

echo "Updating apt"
apt-get update -y

echo "Upgrading anything out of date"
apt-get upgrade -y
apt-get dist-upgrade -y

echo "Installing git"
apt-get install -y git

echo "Installing build tools"
apt-get install -y build-essential devscripts debhelper dh-systemd

echo "Rebuilding locale"
locale-gen en_US.UTF-8
