#!/bin/bash
## bash script for setting a new environment for ubuntu 16.04 LTS
## install: git; vim; shadowsocks-5; ftp-server; sublime text3;

## /*author: chenweiwei*/
## /*email: chenweiwei@ict.ac.cn*/
## /*date: 2018.01.13*/ 

sudo usermod -a -G dialout $USER  ##have the access to the /dev/tty*
sudo apt-get install git -y
sudo apt-get install vim -y

## install the shadowsocks-5 client
sudo add-apt-repository ppa:hzwhuang/ss-qt5 -y
sudo apt-get update
sudo apt-get install shadowsocks-qt5 -y

##auto start the ss5
start_desktopApp_dir="$HOME/.config/autostart"
if [ ! -d $start_desktopApp_dir ]; then
	echo "creat the dir: ${start_desktopApp_dir}"
	mkdir $start_desktopApp_dir
else
	echo " ${start_desktopApp_dir} already exits!";
fi

if [ ! -f "${start_desktopApp_dir}/shadowsocks-qt5.desktop" ]; then
	sudo cp /usr/share/applications/shadowsocks-qt5.desktop ${start_desktopApp_dir}
	echo "create the auto success!"
fi

##intall the ftp server for the chenweiwei
sudo apt-get install vsftpd

ftp_file_dir="/etc/vsftpd.conf"
if [ ! -f $ftp_file_dir ]; then
	echo "create ftp conf file!"
	touch "$ftp_file_dir"
fi
read -t 30 -p "this will cover the origin configure! are you sure?(yes/no):" ftp_cover_input
if [ "$ftp_cover_input" = "y" ] || [ "$ftp_cover_input" = "yes" ] || [ "$ftp_cover_input" = "Y" ]; then
	sudo sh -c 'echo  "listen=NO
listen_ipv6=YES
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
anon_mkdir_write_enable=YES
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES
chown_uploads=YES
chroot_local_user=YES
chroot_list_enable=YES
chroot_list_file=/etc/vsftpd.chroot_list
secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd
rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
ssl_enable=NO"  > '${ftp_file_dir}' ';
else
	echo "no cahnge of the ftp conf file!";
fi

ftp_user_dir="/etc/vsftpd.chroot_list"
if [ ! -f $ftp_user_dir ]; then
	echo "create ftp user file!"
	touch "$ftp_user_dir"
fi
read -t 30 -p "input the user name you want to add to the ftp:" ftp_user_input
if [ ! -n $ftp_user_input ]; then
	sudo sh -c 'echo '${ftp_user_input}' > '${ftp_user_dir}' '
else 
	sudo sh -c 'echo "chenweiwei" > '${ftp_user_dir}' '
fi
sudo /etc/init.d/vsftpd restart


##update the firefox
read -t 10 -p "update the firefox?(yes/no):" update_firefox
if [ "$update_firefox" = "y" ] || [ "$update_firefox" = "yes" ] || [ "$update_firefox" = "Y" ]; then
	sudo apt-get remove firefox
	sudo apt-get install firefox
fi

##install the sogou input method
which sogou-diag
if [ $? -ne 0 ]; then  #judge the sogou installed or not: -ne 0 : not exist
	pushd .
	cd $HOME/Downloads
	wget http://cdn2.ime.sogou.com/dl/index/1509619794/sogoupinyin_2.2.0.0102_amd64.deb&e=1515841472&fn=sogoupinyin_2.2.0.0102_amd64.deb
	sudo dpkg -i sogoupinyin_2.2.0.0102_amd64.deb
	sudo apt-get install -f -y
	sudo apt-get update
	sudo dpkg -i sogoupinyin_2.2.0.0102_amd64.deb
	sh -c 'im-config'
	popd
	sudo reboot
else
	echo "intalled sogou already!"
	sh -c 'fcitx-config-gtk3'
fi





