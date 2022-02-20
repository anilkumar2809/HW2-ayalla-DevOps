#!/bin/bash

# Echo commands run
set -x

# exit when any command fails
set -e

echo "Running rootfs build script"
#!/bin/bash

# Echo commands run
set -x

# exit when any command fails
set -e

echo "Running rootfs build script"
dd if=/dev/zero of=disk.img bs=1M count=5000
mkfs.ext4 disk.img -L cloudimg-rootfs
mkdir -p /rootfs
mount -o offset=0 disk.img /rootfs
wget -nc https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64-root.tar.xz 
tar -xf focal-server-cloudimg-amd64-root.tar.xz -C /rootfs
rm /rootfs/etc/resolv.conf
chroot rootfs bash -c "groupadd -r ubuntu && useradd -m -r -g ubuntu ubuntu -s /bin/bash"
chroot rootfs bash -c "echo 'ubuntu ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers"
chroot rootfs bash -c "echo 'ubuntu:ubuntu' | chpasswd"
chroot /rootfs bash -c 'echo "nameserver 8.8.8.8" | tee /etc/resolv.conf'
chroot /rootfs apt-get update
chroot /rootfs apt-get install python3-pip -qqy
cp /scripts/config.yaml /rootfs/etc/netplan/config.yaml
chroot /rootfs pip3 install notebook --no-input --exists-action=i -q
chroot /rootfs pip3 install pandas --no-input --exists-action=i -q
chroot /rootfs pip3 install seaborn --no-input --exists-action=i -q
chroot /rootfs pip3 install matplotlib --no-input --exists-action=i -q
chroot /rootfs mkdir -p data
chroot /rootfs wget https://raw.githubusercontent.com/datasciencedojo/datasets/master/titanic.csv -P /data
chroot /rootfs bash -c "FK_MACHINE=none apt install linux-virtual -y"
mkdir -p /iso iso/boot iso/isolinux
cp rootfs/boot/vmlinuz /iso/boot
cp rootfs/boot/initrd.img /iso/boot
mv /iso/boot/initrd.img /iso/boot/initrd
cp scripts/isolinux.bin /iso/isolinux
cp scripts/isolinux.cfg /iso/isolinux
cp scripts/ldlinux.c32 /iso/isolinux
umount rootfs
cp --sparse=always disk.img /scripts
mkisofs -o jn.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -J iso
cp jn.iso scripts





 

