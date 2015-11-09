#!/bin/bash

echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu trusty-updates/juno main" > /tmp/cloudarchive-juno.list
mv /tmp/cloudarchive-juno.list /etc/apt/sources.list.d/
apt-get update
apt-get install -qy ubuntu-cloud-keyring