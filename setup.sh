#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root" & echo -en "\007" & spd-say "Please run as root" & wait
  exit
fi

normaluser=""
read -p 'Your user name (used for setting up groups): ' normaluser

apt-get update && apt-get -y upgrade

# ------------------------------------------------------------------------------
# Apt apps
# ------------------------------------------------------------------------------

essential="git parcellite audacious gimp samba adb flameshot curl tlp"
utilities="cheese htop cloc neofetch"
qemukvm="qemu-kvm libvirt-bin bridge-utils virt-manager gir1.2-spiceclientglib-2.0 gir1.2-spiceclientgtk-3.0 ebtables iptables dnsmasq qemu-utils"
fun="cmatrix"

apt-get -y install $essential $utilities $qemukvm $fun

# Monodevelop
apt install apt-transport-https dirmngr -y & echo -en "\007"; spd-say "You might need to confirm key" & apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF & echo "deb https://download.mono-project.com/repo/ubuntu vs-bionic main" | tee /etc/apt/sources.list.d/mono-official-vs.list & apt update & apt-get install monodevelop -y & wait

# Gestures
gpasswd -a $normaluser input & apt-get install xdotool wmctrl libinput-tools & cd /tmp & git clone https://github.com/bulletmark/libinput-gestures.git & cd libinput-gestures/ & make install & libinput-gestures-setup autostart & libinput-gestures-setup start & wait

# Piper 
echo -en "\007"; spd-say "Adding piper ppa, interefere" & add-apt-repository ppa:libratbag-piper/piper-libratbag-git & apt-get update && apt-get install piper -y & wait

# MySQL and MySQL Workbench
cd /tmp & curl -OL https://dev.mysql.com/get/mysql-apt-config_0.8.15-1_all.deb & echo -en "\007"; spd-say "Installing MySQL, you will need to interfere" & dpkg -i mysql-apt-config_0.8.15-1_all.deb  & apt update & apt-get install mysql-server -y & mysql_secure_installation & apt-get install mysql-workbench-community & wait

# Teamviewer
cd /tmp & wget https://download.teamviewer.com/download/linux/signature/TeamViewer2017.asc & apt-key add TeamViewer2017.asc & sh -c 'echo "deb http://linux.teamviewer.com/deb stable main" >> /etc/apt/sources.list.d/teamviewer.list' & apt update & apt install teamviewer

apt-get autoremove -y

# ------------------------------------------------------------------------------
# Snaps
# ------------------------------------------------------------------------------

communication="discord caprine protonmail-desktop-unofficial"
utilities="obs-studio brave bitwarden scrcpy"

snap install $communication $utilities

# Others
snap install skype --classic
# Programming
snap install atom --classic
snap install godot --classic
snap install android-studio --classic
snap install intellij-idea-community --classic
snap install pycharm-community --classic

# ------------------------------------------------------------------------------
# Other apps
# ------------------------------------------------------------------------------

./Joplin_install_and_update.sh --allow-root

# ------------------------------------------------------------------------------
# Settings
# ------------------------------------------------------------------------------

dconf load /org/cinnamon/ < ./cinnamon-preferences.settings
/etc/default/tlp < ./tlp.settings
/etc/libinput-gestures.conf < ./libinput-gestures.settings

echo "Done! Please reboot!" & echo -en "\007" & spd-say "Done! Please reboot!" & wait
