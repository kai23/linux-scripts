# /bin/bash

#On commence par vérifier que le script est lancé en tant que root
if [ `whoami` != "root" ]; then
    echo "Vous devez avoir les privilèges super-utilisateur pour exécuter ce script."
    exit 1
fi


clear
echo "Patientez un instant SVP."
apt-get install dialog > /dev/null
apt-get install usermod > /dev/null

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