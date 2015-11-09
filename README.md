Ryan's Packer Templates
=======================

List
----

- Ubuntu 14.04.2 Server (x64): trusty.2.json
- Ubuntu 14.04.2 Server with OpenStack Juno Repo (x64): trusty.2_juno.json
- CentOS 7.0 1406 (x64): centos7.json

Prerequisites
-------------

I use Fusion, but it would not be difficult to create a VirtualBox version...

1. VMware Fusion
2. Vagrant
3. Vagrant Plugin for Fusion
4. Packer (easy way is Homebrew - `brew install packer`)
5. ISO images

Usage Example 
-------------

- Build the vagrant box

    packer build trusty.2.json

- Add the box into Vagrant

    vagrant box add packer_trusty64_vmware.box --name rbenigno/trusty64