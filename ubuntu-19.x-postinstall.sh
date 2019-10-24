#!/usr/bin/env bash
# ----------------------------- VARIÁVEIS ----------------------------- #
PPA_LIBRATBAG="ppa:libratbag-piper/piper-libratbag-git"
PPA_LUTRIS="ppa:lutris-team/lutris"
PPA_GRAPHICS_DRIVERS="ppa:graphics-drivers/ppa"

URL_WINE_KEY="https://dl.winehq.org/wine-builds/winehq.key"
URL_PPA_WINE="https://dl.winehq.org/wine-builds/ubuntu/"
URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
URL_SIMPLE_NOTE="https://github.com/Automattic/simplenote-electron/releases/download/v1.8.0/Simplenote-linux-1.8.0-amd64.deb"
URL_4K_VIDEO_DOWNLOADER="https://dl.4kdownload.com/app/4kvideodownloader_4.9.2-1_amd64.deb"
URL_INSYNC="https://d2t3ff60b2tol4.cloudfront.net/builds/insync_3.0.20.40428-bionic_amd64.deb"
DOCKER_REPO="https://download.docker.com/linux/ubuntu"
ZSH_REPO="https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh"
DRACULA_TERM_REPO="https://github.com/GalaticStryder/gnome-terminal-colors-dracula"
SOUND_IO_EXT_REPO="https://github.com/kgshank/gse-sound-output-device-chooser.git"

DIRETORIO_DOWNLOADS="$HOME/Downloads/software"
# ---------------------------------------------------------------------- #

# ----------------------------- REQUISITOS ----------------------------- #
## Removendo travas eventuais do apt ##
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock

## Adicionando/Confirmando arquitetura de 32 bits ##
sudo dpkg --add-architecture i386

## Atualizando o repositório ##
sudo apt update -y

## Adicionando repositórios de terceiros e suporte a Snap (Driver Logitech, Lutris e Drivers Nvidia)##
sudo apt-add-repository "$PPA_LIBRATBAG" -y
sudo add-apt-repository "$PPA_LUTRIS" -y
sudo apt-add-repository "$PPA_GRAPHICS_DRIVERS" -y
wget -nc "$URL_WINE_KEY"
sudo apt-key add winehq.key
sudo apt-add-repository "deb $URL_PPA_WINE bionic main"
# ---------------------------------------------------------------------- #

# ----------------------------- EXECUÇÃO ----------------------------- #
sudo apt install snapd -y

## Atualizando o repositório depois da adição de novos repositórios ##
sudo apt update -y

# ----------------------------- LAMP STACK ----------------------------- #
sudo apt install apt-transport-https ca-certificates curl software-properties-common
sudo apt-get install apache2
sudo apt-get install php libapache2-mod-php
sudo echo "<?php phpinfo();" >> /var/www/html/info.php
sudo systemctl restart apache2
curl -X GET http://localhost:80/info.php
sudo apt-get remove docker docker-engine docker.io
curl -fsSL "$DOCKER_REPO/gpg" | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] $DOCKER_REPO $(lsb_release -cs)  stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce
sudo systemctl status docker
sudo usermod -aG docker ${USER}
su - ${USER}
id -nG
docker info

# ----------------------------- CONFIG TERMINAL ----------------------------- #
sudo apt-get install zsh
sudo apt-get install git-core
wget "$ZSH_REPO" -O - | zsh
chsh -s `which zsh`
sudo apt-get install dconf-cli
mkdir "$DIRETORIO_DOWNLOADS"
git clone "$DRACULA_TERM_REPO"     -P "$DIRETORIO_DOWNLOADS"
cd $_ && cd gnome-terminal-colors-dracula && ./install.sh

## Download e instalaçao de programas externos ##
wget -c "$URL_GOOGLE_CHROME"       -P "$DIRETORIO_DOWNLOADS"
wget -c "$URL_SIMPLE_NOTE"         -P "$DIRETORIO_DOWNLOADS"
wget -c "$URL_4K_VIDEO_DOWNLOADER" -P "$DIRETORIO_DOWNLOADS"
wget -c "$URL_INSYNC"              -P "$DIRETORIO_DOWNLOADS"

## Instalando pacotes .deb baixados na sessão anterior ##
sudo dpkg -i $DIRETORIO_DOWNLOADS/*.deb

## Programas do repositório APT##
sudo apt install gnome-tweak-tool
sudo apt install winff -y
sudo apt install guvcview -y
sudo apt install virtualbox -y
sudo apt install flameshot -y
sudo apt install nemo-dropbox -y
sudo apt install steam-installer steam-devices steam:i386 -y
sudo apt install ratbagd -y
sudo apt install piper -y
sudo apt install lutris libvulkan1 libvulkan1:i386 -y
sudo apt install --install-recommends winehq-stable wine-stable wine-stable-i386 wine-stable-amd64 -y
sudo apt install libgnutls30:i386 libldap-2.4-2:i386 libgpg-error0:i386 libxml2:i386 libasound2-plugins:i386 libsdl2-2.0-0:i386 libfreetype6:i386 libdbus-1-3:i386 libsqlite3-0:i386 -y
sudo apt install gnome-shell-extensions

# Enable minimize to click in Ubuntu
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'

# Gnome Shell Extension - Sound Input & Output Device Chooser
git clone "$SOUND_IO_EXT_REPO"     -P "$DIRETORIO_DOWNLOADS" && cd $_
cp --recursive gse-sound-output-device-chooser/sound-output-device-chooser@kgshank.net $HOME/.local/share/gnome-shell/extensions/sound-output-device-chooser@kgshank.net

# Gnome Shell Extension - Multiple Monitor Panels

##Instalando pacotes Flatpak ##
flatpak install flathub com.obsproject.Studio -y

## Instalando pacotes Snap ##
sudo snap install spotify
sudo snap install slack --classic
sudo snap install skype --classic
sudo snap install photogimp
# ---------------------------------------------------------------------- #

# ----------------------------- PÓS-INSTALAÇÃO ----------------------------- #
## Finalização, atualização e limpeza##
sudo apt update && sudo apt dist-upgrade -y
flatpak update
sudo apt autoclean
sudo apt autoremove -y
# ---------------------------------------------------------------------- #