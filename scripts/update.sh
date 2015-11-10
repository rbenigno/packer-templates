#!/bin/bash -eux

if [ -f /etc/os-release ]
then
        . /etc/os-release
else
        echo "ERROR: /etc/os-release not present"
        exit
fi

case $NAME in
    Ubuntu)
        apt-get update
        apt-get -qy dist-upgrade
        ;;
    CentOS*)
        yum update -y
        yum clean all
        ;;
    *)
        echo "Not sure what distro this is: $NAME"
        exit
        ;;
esac

# Reboot
reboot
sleep 60
