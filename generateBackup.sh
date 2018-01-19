#!/usr/bin/env sh
# Customize as necessary
# Run with sudo -H to give permission for operations done here

#Creating backup folder
mkdir $HOME/backup-folder
#Copying the wifi connections info
sudo cp -R /etc/NetworkManager/system-connections $HOME/backup-folder/

#Copying the passwd file (user configurations, not restoring automatically for now due to possible conflicts, just copied for safekeeping)
sudo cp /etc/passwd $HOME/backup-folder/

#Same for groups file
sudo cp /etc/group $HOME/backup-folder/

#Same for fstab, just for safekeeping
sudo cp /etc/fstab $HOME/backup-folder/

#Same as others above
sudo cp /etc/shadow $HOME/backup-folder/
sudo cp /etc/sudoers $HOME/backup-folder/
sudo cp /etc/hostname $HOME/backup-folder/

#Partition table backup
sudo fdisk -l > fdisk.bak

#MBR backup
sudo dd if=$HOME/backup-folder/MBR.bak of=/dev/sda bs=512 count=1

#Hosts file because of spotify or other custom rules set later
sudo cp /etc/hosts $HOME/backup-folder/

#For program installs:

sudo cp -R /etc/apt/sources.list* $HOME/backup-folder/
sudo apt-key exportall > $HOME/backup-folder/Repo.keys

dpkg --get-selections > $HOME/backup-folder/my-packages.list
