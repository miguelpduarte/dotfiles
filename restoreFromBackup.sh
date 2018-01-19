#!/usr/bin/env sh
# Customize as necessary
# Should match the generateBackup.sh script used
# Run with sudo to give permission for operations done here

#Restoring the system connections info
sudo cp -R $HOME/backup-folder/system-connections /etc/NetworkManager/

#If desired, restore fstab (Uncomment to activate)
#sudo cp $HOME/backup-folder/fstab /etc/fstab

#Hosts file for spotify
sudo cp $HOME/backup-folder/hosts /etc/hosts

#Restore MBR
#sudo dd if=$HOME/backup-folder/MBR.bak of=/dev/sda bs=512 count=1

#Reinstalling the saved packages
sudo apt-key add $HOME/backup-folder/Repo.keys
sudo cp -R $HOME/backup-folder/sources.list* /etc/apt/
sudo apt-get update
sudo apt-get install dselect
sudo dselect update
sudo dpkg --set-selections < $HOME/backup-folder/my-packages.list
sudo apt-get dselect-upgrade -y
