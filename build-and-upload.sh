#!/bin/bash

# From http://dailyraisin.com/read-json-value-in-bash/
function readJson {
  UNAMESTR=`uname`
  if [[ "$UNAMESTR" == 'Linux' ]]; then
    SED_EXTENDED='-r'
  elif [[ "$UNAMESTR" == 'Darwin' ]]; then
    SED_EXTENDED='-E'
  fi; 

  VALUE=`grep -m 1 "\"${2}\"" ${1} | sed ${SED_EXTENDED} 's/^ *//;s/.*: *"//;s/",?//'`

  if [ ! "$VALUE" ]; then
    echo "Error: Cannot find \"${2}\" in ${1}" >&2;
    exit 1;
  else
    echo $VALUE ;
  fi; 
}

# Load variables from JSON file
PACKER_REMOTE_HOST=`readJson packer-remote-info.json packer_remote_host`
PACKER_REMOTE_USERNAME=`readJson packer-remote-info.json packer_remote_username`
PACKER_REMOTE_PASSWORD=`readJson packer-remote-info.json packer_remote_password`
PACKER_REMOTE_DATASTORE=`readJson packer-remote-info.json packer_remote_datastore`
PACKER_REMOTE_NETWORK=`readJson packer-remote-info.json packer_remote_network`

if [ -d "./output/$PACKER_VM_NAME" ]; then
  echo "removing previous build of $PACKER_VM_NAME"
  rm -r "./output/$PACKER_VM_NAME/"
fi

BUILD_TIME=`date +"%Y-%m-%d-%H%M"`

echo "starting packer build of $PACKER_VM_NAME ($BUILD_TIME)"
packer build -var-file=packer-remote-info.json $PACKER_VM_NAME.json

echo "uploading $PACKER_VM_NAME to $PACKER_REMOTE_HOST"
TARGET_VM_NAME="${PACKER_VM_NAME}_${BUILD_TIME}"
ovftool -ds="$PACKER_REMOTE_DATASTORE" --name="$TARGET_VM_NAME" \
     --net:"nat"="$PACKER_REMOTE_NETWORK" -dm=thin \
     "./output/$PACKER_VM_NAME/packer-$PACKER_VM_NAME.vmx" \
     "vi://$PACKER_REMOTE_USERNAME:$PACKER_REMOTE_PASSWORD@$PACKER_REMOTE_HOST"


# --- https://github.com/sdorsett/packer-templates

# echo "registering ${PACKER_VM_NAME} virtual machine on ${PACKER_REMOTE_HOST}"
# /usr/bin/sshpass -p ${PACKER_REMOTE_PASSWORD} ssh root@${PACKER_REMOTE_HOST} "vim-cmd solo/registervm /vmfs/volumes/${PACKER_REMOTE_DATASTORE}/output-${PACKER_VM_NAME}/*.vmx"

# mkdir -p /root/box_files/ovf/empty_dir/
# mkdir -p /root/box_files/vmx/empty_dir/

# rm -rf /root/box_files/ovf/${PACKER_VM_NAME}
# rm -rf /root/box_files/vmx/${PACKER_VM_NAME}

# echo "output of /vmfs/volumes/${PACKER_REMOTE_DATASTORE}/output-${PACKER_VM_NAME}/*.vmxf:"
# /usr/bin/sshpass -p ${PACKER_REMOTE_PASSWORD} ssh root@${PACKER_REMOTE_HOST} "cat /vmfs/volumes/${PACKER_REMOTE_DATASTORE}/output-${PACKER_VM_NAME}/*.vmxf"

# ovftool vi://root:${PACKER_REMOTE_PASSWORD}@${PACKER_REMOTE_HOST}/${PACKER_VM_NAME} /root/box_files/ovf/
# ovftool -tt=vmx vi://root:${PACKER_REMOTE_PASSWORD}@${PACKER_REMOTE_HOST}/${PACKER_VM_NAME} /root/box_files/vmx/

# echo "creating metadata.json and Vagrantfile files in ovf virtual machine directory"
# echo '{"provider":"vmware_ovf"}' >> /root/box_files/ovf/${PACKER_VM_NAME}/metadata.json
# touch /root/box_files/ovf/${PACKER_VM_NAME}/Vagrantfile
# cd /root/box_files/ovf/empty_dir/
# cd /root/box_files/ovf/${PACKER_VM_NAME}/

# echo "compressing ovf virtual machine files to /var/www/html/box-files/${PACKER_VM_NAME}-vmware_ovf-1.0.box" 
# tar cvzf /var/www/html/box-files/$PACKER_VM_NAME-vmware_ovf-1.0.box ./*

# echo "creating metadata.json and Vagrantfile files in vmx virtual machine directory"
# echo '{"provider":"vmware_desktop"}' >> /root/box_files/vmx/${PACKER_VM_NAME}/metadata.json
# touch /root/box_files/vmx/${PACKER_VM_NAME}/Vagrantfile
# cd /root/box_files/vmx/empty_dir/
# cd /root/box_files/vmx/${PACKER_VM_NAME}/

# echo "compressing vmx virtual machine files to /var/www/html/box-files/${PACKER_VM_NAME}-vmware_desktop-1.0.box"
# tar cvzf /var/www/html/box-files/$PACKER_VM_NAME-vmware_desktop-1.0.box ./*

# echo "cleaning up /root/box_files directories"
# rm -rf /root/box_files/ovf/$PACKER_VM_NAME
# rm -rf /root/box_files/vmx/$PACKER_VM_NAME

# echo "deleting $PACKER_VM_NAME from $PACKER_REMOTE_HOST"
# /usr/bin/sshpass -p ${PACKER_REMOTE_PASSWORD} ssh root@${PACKER_REMOTE_HOST}  "vim-cmd vmsvc/getallvms | grep ${PACKER_VM_NAME} | cut -d ' ' -f 1 | xargs vim-cmd vmsvc/destroy"

# echo "packer build of $PACKER_VM_NAME has been  completed"
