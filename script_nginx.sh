# /bin/bash

#On commence par vérifier que le script est lancé en tant que root
if [ `whoami` != "root" ]; then
    echo "Vous devez avoir les privilèges super-utilisateur pour exécuter ce script."
    exit 1
fi

#On installe dialog pour afficher les messages
clear
echo "Patientez un instant SVP."
apt-get install dialog > /dev/null

dialog --title "Debian SeedBox Installer v1.0" --clear --yesno "Ce script est fait pour être exécuté sur une installation Debian/Ubuntu vierge.
L'installation prendra environ 20 minutes et se déroulera en plusieurs étapes successives :
- Installation et configuration de rTorrent
- Installation et configuration de ruTorrent et ses plugins
- Installation et configuration de nginx
- Ajout d'un utilisateur pour ruTorrent
Ce script est fourni tel quel, vous l'utilisez en toute connaissance de cause, à vos risques et périls.
Souhaitez-vous continuer?" 0 0

#On teste le code de retour de dialog pour savoir si l'utilisateur a répondu oui ou non
if [ $? -eq 1 ]
then
    clear
    exit 1
fi

cmd=(dialog --separate-output --checklist "Choisir ce que vous souhaitez installer en plus" 22 76 16)
options=(1 "MySQL et phpMyAdmin" off    # any option can be set to default to "on"
         2 "Seafile" off
         3 "OhMyZsh" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
mysql=false;
seafile=false;
omzsh=false;
for choice in $choices
do
    case $choice in
        1)
           mysql=true
           ;;
        2)
           seafile=true
           ;;
        3)
           omzsh=true
           ;;
    esac
done

echo "0" | dialog --no-cancel --gauge "Mise à jour du système" 0 0
apt-get update -y > /dev/null
echo "10" | dialog --no-cancel --gauge "Mise à jour du système" 0 0
apt-get upgrade -y > /dev/null
clear
echo "33" | dialog --no-cancel --gauge "Installation des paquets nécessaires" 0 0
sudo apt-get install -y htop > /dev/null
clear
echo "35" | dialog --no-cancel --gauge "Installation des paquets nécessaires" 0 0
sudo apt-get install -y build-essential > /dev/null
clear
echo "38" | dialog --no-cancel --gauge "Installation des paquets nécessaires" 0 0
sudo apt-get install -y pkg-config > /dev/null
clear
echo "40" | dialog --no-cancel --gauge "Installation des paquets nécessaires" 0 0
sudo apt-get install -y libcurl4-openssl-dev > /dev/null
clear
echo "43" | dialog --no-cancel --gauge "Installation des paquets nécessaires" 0 0
sudo apt-get install -y libsigc++-2.0-dev > /dev/null
clear
echo "48" | dialog --no-cancel --gauge "Installation des paquets nécessaires" 0 0
sudo apt-get install -y libncurses5-dev > /dev/null
clear
echo "50" | dialog --no-cancel --gauge "Installation des paquets nécessaires" 0 0
sudo apt-get install -y nginx > /dev/null
clear
echo "55" | dialog --no-cancel --gauge "Installation des paquets nécessaires" 0 0
sudo apt-get install -y vim > /dev/null
clear
echo "56" | dialog --no-cancel --gauge "Installation des paquets nécessaires" 0 0
sudo apt-get install -y nano > /dev/null
clear
echo "58" | dialog --no-cancel --gauge "Installation des paquets nécessaires" 0 0
sudo apt-get install -y screen > /dev/null
clear
echo "59" | dialog --no-cancel --gauge "Installation des paquets nécessaires" 0 0
sudo apt-get install -y subversion > /dev/null
clear
echo "60" | dialog --no-cancel --gauge "Installation des paquets nécessaires" 0 0
sudo apt-get install -y apache2-utils > /dev/null
clear
echo "65" | dialog --no-cancel --gauge "Installation des paquets nécessaires" 0 0
sudo apt-get install -y curl > /dev/null
clear
echo "66" | dialog --no-cancel --gauge "Installation des paquets nécessaires" 0 0
sudo apt-get install -y php5 > /dev/null
clear
echo "69" | dialog --no-cancel --gauge "Installation des paquets nécessaires" 0 0
sudo apt-get install -y php5-cli > /dev/null
clear
echo "70" | dialog --no-cancel --gauge "Installation des paquets nécessaires" 0 0
sudo apt-get install -y php5-fpm > /dev/null
clear
echo "71" | dialog --no-cancel --gauge "Installation des paquets nécessaires" 0 0
sudo apt-get install -y php5-curl > /dev/null
clear
echo "71" | dialog --no-cancel --gauge "Installation des paquets nécessaires" 0 0
sudo apt-get install -y php5-geoip > /dev/null
clear
echo "73" | dialog --no-cancel --gauge "Installation des paquets nécessaires" 0 0
sudo apt-get install -y git > /dev/null
clear
echo "74" | dialog --no-cancel --gauge "Installation des paquets nécessaires" 0 0
sudo apt-get install -y unzip > /dev/null
clear
echo "78" | dialog --no-cancel --gauge "Installation des paquets nécessaires" 0 0
sudo apt-get install -y unrar > /dev/null
clear
echo "79" | dialog --no-cancel --gauge "Installation des paquets nécessaires" 0 0
sudo apt-get install -y rar > /dev/null
clear
echo "80" | dialog --no-cancel --gauge "Installation des paquets nécessaires" 0 0
sudo apt-get install -y zip > /dev/null
clear
echo "83" | dialog --no-cancel --gauge "Installation des paquets nécessaires" 0 0
sudo apt-get install -y buildtorrent > /dev/null
clear
echo "85" | dialog --no-cancel --gauge "Installation des paquets nécessaires" 0 0
sudo apt-get install -y mediainfo > /dev/null
clear
echo "90" | dialog --no-cancel --gauge "Installation des paquets nécessaires" 0 0
sudo add-apt-repository ppa:jon-severinsson/ffmpeg --yes  > /dev/null
sudo apt-get update > /dev/null
sudo apt-get install -y ffmpeg  > /dev/null
clear
echo "100" | dialog --no-cancel --gauge "Installation des paquets nécessaires" 0 0

echo "0" | dialog --no-cancel --gauge "Installation et configuration de rTorrent" 0 0
cd /tmp 
svn checkout http://svn.code.sf.net/p/xmlrpc-c/code/stable xmlrpc-c > /dev/null
cd xmlrpc-c/ 
./configure > /dev/null
clear
echo "30" | dialog --no-cancel --gauge "Installation et configuration de rTorrent" 0 0
make > /dev/null
clear
echo "15" | dialog --no-cancel --gauge "Installation et configuration de rTorrent" 0 0
make install > /dev/null
clear
echo "20" | dialog --no-cancel --gauge "Installation et configuration de rTorrent" 0 0

cd /tmp
wget http://libtorrent.rakshasa.no/downloads/libtorrent-0.13.4.tar.gz
echo "30" | dialog --no-cancel --gauge "Installation et configuration de rTorrent" 0 0
tar --verbose --gzip --extract --file libtorrent-0.13.4.tar.gz
cd libtorrent-0.13.4
./configure
echo "40" | dialog --no-cancel --gauge "Installation et configuration de rTorrent" 0 0
make
echo "45" | dialog --no-cancel --gauge "Installation et configuration de rTorrent" 0 0
make install
echo "50" | dialog --no-cancel --gauge "Installation et configuration de rTorrent" 0 0

cd /tmp
wget http://libtorrent.rakshasa.no/downloads/rtorrent-0.9.4.tar.gz
echo "60" | dialog --no-cancel --gauge "Installation et configuration de rTorrent" 0 0
tar --verbose --gzip --extract --file rtorrent-0.9.4.tar.gz
echo "70" | dialog --no-cancel --gauge "Installation et configuration de rTorrent" 0 0
cd rtorrent-0.9.4
./configure --with-xmlrpc-c
echo "72" | dialog --no-cancel --gauge "Installation et configuration de rTorrent" 0 0
make
echo "75" | dialog --no-cancel --gauge "Installation et configuration de rTorrent" 0 0
make install
echo "85" | dialog --no-cancel --gauge "Installation et configuration de rTorrent" 0 0

ldconfig

echo "90" | dialog --no-cancel --gauge "Installation et configuration de rTorrent" 0 0
mkdir /var/www
cd /var/www
git clone https://github.com/Novik/ruTorrent.git rutorrent

cd /var/www/rutorrent/plugins/
svn co http://rutorrent-chat.googlecode.com/svn/trunk/ chat

cd /var/www/rutorrent/plugins/
svn co http://rutorrent-logoff.googlecode.com/svn/trunk/ logoff

cd /var/www/rutorrent/plugins/
wget http://rutorrent-tadd-labels.googlecode.com/files/lbll-suite_0.8.1.tar.gz
tar --verbose --gzip --extract --file lbll-suite_0.8.1.tar.gz
rm lbll-suite_0.8.1.tar.gz

cd /var/www/rutorrent/plugins/
git clone https://github.com/xombiemp/rutorrentMobile.git mobile

cd /var/www/rutorrent/plugins/
svn checkout http://rutorrent-pausewebui.googlecode.com/svn/trunk/ pausewebui

cd /var/www/rutorrent/plugins/
svn checkout http://svn.rutorrent.org/svn/filemanager/trunk/filemanager

echo "95" | dialog --no-cancel --gauge "Installation et configuration de rTorrent" 0 0
chown --recursive www-data:www-data /var/www/rutorrent

echo "<?php
    \$useExternal = 'buildtorrent';
    \$pathToCreatetorrent = '/usr/bin/buildtorrent';
    \$recentTrackersMaxCount         = 15;
" > /var/www/rutorrent/plugins/create/conf.php


echo "<?php
\$fm['tempdir'] = '/tmp';   
\$fm['mkdperm'] = 755;  
\$pathToExternals['rar'] = '/usr/bin/rar';
\$pathToExternals['zip'] = '/usr/bin/zip';
\$pathToExternals['unzip'] = '/usr/bin/unzip';
\$pathToExternals['tar'] = '/bin/tar';
\$pathToExternals['gzip'] = '/bin/gzip';
\$pathToExternals['bzip2'] = '/bin/bzip2';
\$fm['archive']['types'] = array('rar', 'zip', 'tar', 'gzip', 'bzip2');
\$fm['archive']['compress'][0] = range(0, 5);
\$fm['archive']['compress'][1] = array('-0', '-1', '-9');
\$fm['archive']['compress'][2] = \$fm['archive']['compress'][3] = \$fm['archive']['compress'][4] = array(0);
" > /var/www/rutorrent/plugins/filemanager/conf.php

sed -i "s/plugin.sort = 'name';/plugin.sort = '-addtime';/g" /var/www/rutorrent/plugins/mobile/init.js
sed -i 's/;listen.mode/listen.mode/g' /etc/php5/fpm/pool.d/www.conf
sed -i 's/expose_php = On/expose_php = Off/g' /etc/php5/fpm/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 800M/g' /etc/php5/fpm/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 2000M/g' /etc/php5/fpm/php.ini
sed -i 's/;date.timezone =/date.timezone = Europe\/Paris/g' /etc/php5/fpm/php.ini
echo "100" | dialog --no-cancel --gauge "Installation et configuration de rTorrent" 0 0


echo "0" | dialog --no-cancel --gauge "Configuration de Nginx" 0 0
service php5-fpm restart

mkdir /etc/nginx/passwd
mkdir /etc/nginx/ssl
touch /etc/nginx/passwd/rutorrent_passwd

echo "user www-data;
worker_processes auto;
pid /var/run/nginx.pid;

events {
    worker_connections 1024; 
    use epoll; # gestionnaire d'évènements epoll (kernel 2.6+)
}

http {
    include /etc/nginx/mime.types;
    default_type  application/octet-stream;

    access_log /var/log/nginx/access.log combined;
    error_log /var/log/nginx/error.log error;
    
    sendfile on;
    keepalive_timeout 15;
    keepalive_disable msie6;
    keepalive_requests 100;
    tcp_nopush on;
    tcp_nodelay off;
    server_tokens off;
    
    gzip on;
    gzip_comp_level 5;
    gzip_min_length 512;
    gzip_buffers 4 8k;
    gzip_proxied any;
    gzip_vary on;
    gzip_disable \"msie6\";
    gzip_types
        text/css
        text/javascript
        text/xml
        text/plain
        text/x-component
        application/javascript
        application/x-javascript
        application/json
        application/xml
        application/rss+xml
        application/vnd.ms-fontobject
        font/truetype
        font/opentype
        image/svg+xml;

    include /etc/nginx/sites-enabled/*.conf;
}" > /etc/nginx/nginx.conf

echo "location ~ \.php\$ {
	fastcgi_index index.php;
	fastcgi_pass unix:/var/run/php5-fpm.sock;
	fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
	include /etc/nginx/fastcgi_params;
}" > /etc/nginx/conf.d/php

echo "location ~* \.(jpg|jpeg|gif|css|png|js|woff|ttf|svg|eot)\$ {
    expires 30d;
    access_log off;
}

location ~* \.(eot|ttf|woff|svg)\$ {
    add_header Acccess-Control-Allow-Origin *;
}" > /etc/nginx/conf.d/cache

echo "10" | dialog --no-cancel --gauge "Configuration de Nginx" 0 0

mkdir /etc/nginx/sites-enabled

echo "server {
    listen 80 default_server;
    listen 443 default_server ssl;
    server_name _;

    charset utf-8;
    index index.html index.php;
    client_max_body_size 10M;

    ssl_certificate /etc/nginx/ssl/server.crt;
    ssl_certificate_key /etc/nginx/ssl/server.key;

    access_log /var/log/nginx/rutorrent-access.log combined;
    error_log /var/log/nginx/rutorrent-error.log error;
    
    error_page 500 502 503 504 /50x.html;
    location = /50x.html { root /usr/share/nginx/html; }

    auth_basic \"seedbox\";
    auth_basic_user_file \"/etc/nginx/passwd/rutorrent_passwd\";
    
    location = /favicon.ico {
        access_log off;
        log_not_found off;
    }
    
    ## début config rutorrent ##

    location ^~ /rutorrent {
	root /var/www;
	include /etc/nginx/conf.d/php;
	include /etc/nginx/conf.d/cache;

	location ~ /\.svn {
		deny all;
	}

	location ~ /\.ht {
		deny all;
	}
    }

    location ^~ /rutorrent/conf/ {
	deny all;
    }

    location ^~ /rutorrent/share/ {
	deny all;
    }
    
    ## fin config rutorrent ##

}" > /etc/nginx/sites-enabled/rutorrent.conf

cd /etc/nginx/ssl/

echo '6ffa2z8a866df7' > .passwd
openssl genrsa -des3 -out secure.key -passout file:.passwd 1024
openssl req -new -key secure.key -out server.csr -passin file:.passwd  -subj "/C=FR/ST=IDF/L=PARIS/O=toto/OU=PRE-PROD/CN=kim.su.fi"
openssl rsa -in secure.key -out server.key -passin file:.passwd
openssl x509 -req -days 3650 -in server.csr -signkey server.key -out server.crt
rm secure.key server.csr .passwd
rm /etc/logrotate.d/nginx

echo "/var/log/nginx/*.log {
    daily
    missingok
    rotate 7
    compress
    delaycompress
    notifempty
    create 640 root
    sharedscripts
        postrotate
            [ -f /var/run/nginx.pid ] && kill -USR1 `cat /var/run/nginx.pid`
        endscript
}" > /etc/logrotate.d/nginx

#On commence par vérifier que le script est lancé en tant que root
if [ `whoami` != "root" ]; then
    echo "Vous devez avoir les privilèges super-utilisateur pour exécuter ce script."
    exit 1
fi

echo "100" | dialog --no-cancel --gauge "Configuration de Nginx" 0 0

clear
dialog --title "Debian SeedBox Installer v1.0" --clear --yesno "Ce script permet d'ajouter un utilisateur. Souhaitez-vous continuer?" 0 0
#On teste le code de retour de dialog pour savoir si l'utilisateur a répondu oui ou non
if [ $? -eq 1 ]
then
	clear
	exit 1
fi

#On demande un login pour la SeedBox
data=$(tempfile 2>/dev/null)
trap "rm -f $data" 0 1 2 5 15

dialog --no-cancel --title "Debian SeedBox Installer v1.1" --inputbox "Entrez un login pour votre SeedBox.
(notez-le pour ne pas l'oublier)" 0 0 2> $data
user_temp=`cat $data`
user="${user_temp,,}"
user_maj="${user_temp^^}"

#On demande un port
data=$(tempfile 2>/dev/null)
trap "rm -f $data" 0 1 2 5 15

dialog --no-cancel --title "Debian SeedBox Installer v1.1" --inputbox "Entrez un port pour votre SeedBox.
(notez-le pour ne pas l'oublier)" 0 0 2> $data
port=`cat $data`

#On demande un mot de passe pour la SeedBox
data=$(tempfile 2>/dev/null)
trap "rm -f $data" 0 1 2 5 15

dialog --no-cancel --title "Debian SeedBox Installer v1.0" --passwordbox "Entrez un mot de passe pour votre SeedBox.
Par sécurité le mot de passe ne sera pas affiché, de plus, le mot de passe ne vous sera demandé qu'une fois. Soyez-donc attentif à votre frappe, et notez le mot de passe pour ne pas l'oublier." 0 0 2> $data
password=`cat $data`

mkdir --parents /home/$user/watch
mkdir /home/$user/torrents
mkdir /home/$user/.session

useradd --shell /bin/bash --home /home/$user $user
usermod --password $(echo "$password" | openssl passwd -1 -stdin) $user

echo "scgi_port = 127.0.0.1:$port
encoding_list = UTF-8
port_range = 45000-65000
port_random = no
check_hash = no
directory = /home/$user/torrents
session = /home/$user/.session
encryption = allow_incoming, try_outgoing, enable_retry
schedule = watch_directory,1,1,"load_start=/home/$user/watch/*.torrent"
schedule = untied_directory,5,5,"stop_untied=/home/$user/watch/*.torrent"
use_udp_trackers = yes
dht = off
peer_exchange = no
min_peers = 40
max_peers = 100
min_peers_seed = 10
max_peers_seed = 50
max_uploads = 15
execute = {sh,-c,/usr/bin/php /var/www/rutorrent/php/initplugins.php $user &}
schedule = espace_disque_insuffisant,1,30,close_low_diskspace=500M" > /home/$user/.rtorrent.rc

chown --recursive $user:$user /home/$user
chown root:$user /home/$user
chmod 755 /home/$user

to="location /$user_maj {
        include scgi_params;
        scgi_pass 127.0.0.1:$port;
        auth_basic \"seedbox\";
        auth_basic_user_file \"/etc/nginx/passwd/rutorrent_passwd_$user\";
    }
    ## fin config rutorrent ##"
awk -v r="$to" '{gsub(/## fin config rutorrent ##/,r)}1' /etc/nginx/sites-enabled/rutorrent.conf > temp
mv temp /etc/nginx/sites-enabled/rutorrent.conf

htpasswd -mbc /etc/nginx/passwd/rutorrent_passwd_$user $user $password
cat /etc/nginx/passwd/rutorrent_passwd_$user >> /etc/nginx/passwd/rutorrent_passwd
chmod 640 /etc/nginx/passwd/*
chown --changes www-data:www-data /etc/nginx/passwd/*

service nginx restart

mkdir /var/www/rutorrent/conf/users/$user

echo "<?php
\$pathToExternals['curl'] = '/usr/bin/curl';
\$topDirectory = '/home/$user';
\$scgi_port = $port;
\$scgi_host = '127.0.0.1';
\$XMLRPCMountPoint = '/$user_maj';" > /var/www/rutorrent/conf/users/$user/config.php

echo "[default]
enabled = user-defined
canChangeToolbar = yes
canChangeMenu = yes
canChangeOptions = yes
canChangeTabs = yes
canChangeColumns = yes
canChangeStatusBar = yes
canChangeCategory = yes
canBeShutdowned = yes
[ipad]
enabled = no
[httprpc]
enabled = no
[retrackers]
enabled = no
[rpc]
enabled = no
[rutracker_check]
enabled = no" > /var/www/rutorrent/conf/users/$user/plugins.ini


echo "#!/usr/bin/env bash
 
# Dépendance : screen, killall et rtorrent
### BEGIN INIT INFO
# Provides:          $user-rtorrent
# Required-Start:    $syslog $network
# Required-Stop:     $syslog $network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start daemon at boot time
# Description:       Start-Stop rtorrent user session
### END INIT INFO
 
## Début configuration ##
user=\"$user\"
## Fin configuration ##
 
rt_start() {
    su --command=\"screen -dmS ${user}-rtorrent rtorrent\" \"${user}\"
}
 
rt_stop() {
    killall --user \"${user}\" screen
}
 
case \"\$1\" in
start) echo \"Starting rtorrent...\"; rt_start
    ;;
stop) echo \"Stopping rtorrent...\"; rt_stop
    ;;
restart) echo \"Restart rtorrent...\"; rt_stop; sleep 1; rt_start
    ;;
*) echo \"Usage: \$0 {start|stop|restart}\"; exit 1
    ;;
esac
exit 0" > /etc/init.d/$user-rtorrent

chmod +x /etc/init.d/$user-rtorrent
update-rc.d $user-rtorrent defaults
service $user-rtorrent start