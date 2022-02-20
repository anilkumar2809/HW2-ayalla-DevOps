#!/bin/bash
cd lib/scripts
VBoxManage convertdd disk.img disk.vmdk
cd ../..
VBoxManage createvm --name jn --register
VBoxManage storagectl jn --name IDE --add ide
VBoxManage storageattach jn --storagectl IDE --port 0 --device 0 --type dvddrive --medium lib/scripts/jn.iso
VBoxManage storagectl jn --name SCSI --add scsi
VBoxManage storageattach jn --storagectl SCSI --port 1 --device 0 --type hdd --medium lib/scripts/disk.vmdk
VBoxManage modifyvm jn --memory 1024 --cpus 1
VBoxManage modifyvm jn --uart1 0x3f8 4 --uartmode1 disconnected
VBoxManage modifyvm jn --nic1 nat
VBoxManage modifyvm jn --nictype1 virtio
VBoxManage modifyvm jn --natpf1 jupyter,tcp,,8888,,8888
