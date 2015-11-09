Vagrant Box Prep
================

Build an updated Ubuntu image with the Juno repo pre-added.  The ansible playbook will run on a default image, it just takes longer.

Prerequisites
-------------

I use Fusion, but it would not be difficult to create a VirtualBox version...

1. VMware Fusion
2. Vagrant
3. Vagrant Plugin for Fusion
4. Packer (easy way is Homebrew - `brew install packer`)
5. Ubuntu 14.04.2 server x64 ISO

Usage 
-----

- Update the trusty.2_juno.json with the path to your ISO
- Build the vagrant box

    packer build trusty.2_juno.json

- Add the box into Vagrant

    vagrant box add packer_trusty64_juno_vmware.box --name rbenigno/trusty64_juno