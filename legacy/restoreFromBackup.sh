#!/usr/bin/env sh
# Customize as necessary
# Should match the generateBackup.sh script used
# Run with sudo to give permission for operations done here

#Common fixes:
#Some are already contemplated but for example not having read access to sources.list* caused problems
#Other than that, "dpkg: warning: package not in database" ocurrs if the package in "my-packages.list" has packages that are not in the added repos
#That has to be fixed by manually editing that file and removing the packages that cause problems (probably are packages that you need to download the .deb file for or compile from source)

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
#Adding read permissions, prevents "dpkg: warning: package not in database" errors that cause the installations to fail
sudo chmod +r /etc/apt/sources.list* -R
sudo apt-get update
sudo apt-get install dselect
sudo dselect update
sudo dpkg --set-selections < $HOME/backup-folder/my-packages.list
sudo apt-get dselect-upgrade -y
