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
        # apt-get install -qy open-vm-tools
        apt-get -qy dist-upgrade

        # Hmm, reboot-required flag not always set after kernel update?
        #if [ -f /var/run/reboot-required ]; then
            reboot
            sleep 60
        #fi
        ;;
    CentOS*)
        # Install Updates
        yum update -y
        yum clean all
        ;;
esac