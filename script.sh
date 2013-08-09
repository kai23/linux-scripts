# /bin/bash

# On met d'abord le système à jour
apt-get update -y && apt-get upgrade -y

# On installe tout ce dont on va avoir besoin
apt-get install -y apache2 apache2-doc apache2-mpm-prefork apache2-utils libexpat1 ssl-cert libapache2-mod-php5 php5 php5-common php5-curl php5-dev php5-gd php5-idn php-pear php5-imagick php5-imap php5-json php5-mcrypt php5-memcache php5-mhash php5-ming php5-mysql php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl libapache2-mod-scgi build-essential make gcc autoconf curl libcurl3 libcurl4-openssl-dev  zip unzip gcc libc6-dev linux-kernel-headers diffutils wget bzip2 make screen ffmpeg libcppunit-dev libncurses5-dev libncursesw5-dev subversion libsigc++ dtach imagemagick proftpd zsh git



###########################
#
# Installation de Rtorrent
#
###########################

# Retour à la maison !
cd
# Soyons propres
mkdir sources
cd sources

# on récupère tout
svn co https://xmlrpc-c.svn.sourceforge.net/svnroot/xmlrpc-c/advanced/ xmlrpc-c
wget http://libtorrent.rakshasa.no/downloads/libtorrent-0.13.2.tar.gz
wget http://libtorrent.rakshasa.no/downloads/rtorrent-0.9.2.tar.gz

# on extrait !
tar xvzf  libtorrent-0.13.2.tar.gz rtorrent-0.9.2.tar.gz 
tar xvzf  libtorrent-0.13.2.tar.gz 
tar xvzf rtorrent-0.9.2.tar.gz 
rm *.tar.gz

#XMLRPC
cd xmlrpc-c/
./configure
make && make install

#libtorrent
cd ../libtorrent-0.13.2/
./configure
make && make install

#rtorrent
cd ../rtorrent-0.9.2/
./autogen.sh 
./configure --with-xmlrpc-c
make && make install

## On nettoie
cd
rm -Rf sources

#Y'a parfois une petite erreur avec la librairie 
ldconfig


###########################
# 
# Configuration de Rtorrent
#
###########################

# Création des repertoires
mkdir ~/session/
mkdir /var/www/downloads/

# des fois que…
chmod -R 777 /var/www/downloads/
chmod -R 777 ~/session/

cd
echo "directory = /var/www/downloads
session = ~/session
port_range = 6890-6999
port_random = no
check_hash = no
use_udp_trackers = yes
schedule = watch_directory,15,15,load_start=~/watch/*.torrent
dht = auto
dht_port = 6881
scgi_port = 127.0.0.1:5000" > .rtorrent.rc



# On lance rTorrent en arrière plan
killall rtorrent
screen -fn -dmS rtd nice -19 rtorrent


############################################
#
# Installtion de RuTorrent et de ses plugins
#
############################################

cd /var/www
svn checkout http://rutorrent.googlecode.com/svn/trunk/rutorrent/
cd rutorrent
rm -R plugins
svn checkout http://rutorrent.googlecode.com/svn/trunk/plugins/
chmod -R 777 /var/www/



##########################
#
# Apache et .htaccess
#
##########################
cd /var/www/

# Génération du .htpasswd
htpassword=totodu23
htpasswd -mbc .htpasswd admin $htpassword


# Génération des .htaccess
echo "AuthName \"Restricted\"
AuthType Basic
AuthUserFile \"/var/www/.htpasswd\"
Require valid-user" > .htaccess # Protege la racine du serveur web

# Configuration et activation des .htaccess dans Apache2

cd /etc/apache2/sites-enabled/
sed '0,/AllowOverride None/ s//AllowOverride All/' 000-default > 000-default.1
sed '0,/AllowOverride None/ s//AllowOverride All/' 000-default.1 > 000-default


# activation des différents trucs
a2enmod rewrite
a2enmod ssl
a2enmod auth_digest
a2enmod scgi
echo "SCGIMount /RPC2 127.0.0.1:5000" >> /etc/apache2/apache2.conf 

service apache2 restart



##########################
#
#   _h5ai
#
##########################

cd /var/www/
wget http://release.larsjung.de/h5ai/h5ai-0.23.0.zip
unzip h5ai-0.23.0.zip
rm h5ai-0.23.0.zip
rm index.html
echo "DirectoryIndex  index.html  index.php  /_h5ai/server/php/index.php" >> .htaccess 
chmod -R 777 /var/www/

####################"
#
#  Mediainfo
#
####################

cd
mkdir mediainfo
cd mediainfo

# On récupère !
wget http://mediaarea.net/download/binary/libzen0/0.4.28/libzen0_0.4.28-1_amd64.Debian_6.0.deb
wget http://mediaarea.net/download/binary/libmediainfo0/0.7.61/libmediainfo0_0.7.61-1_amd64.Debian_6.0.deb
wget http://mediaarea.net/download/binary/mediainfo/0.7.61/mediainfo_0.7.61-1_amd64.Debian_6.0.deb

# On installe !
dpkg -i *.deb

# On clean !
cd && rm -Rf mediainfo


####################
#
#  Le FTP
#
####################

# on va changer le dossier de FTP par defaut
cd /etc/proftpd/
sed -i  's/^# DefaultRoot/DefaultRoot/g' proftpd.conf
sed -i  's/~/\/var\/www\/downloads\//g' proftpd.conf

# Desactivation IPv6
sed -i  's/UseIPv6[[:space:]]*on/UseIPv6 off/g' proftpd.conf

# autorisation de reprise d'upload
echo "AllowStoreRestart on" >> proftpd.conf

#Autoriser la reprise d'un téléchargement de fichier
echo "AllowRetrieveRestart on" >> proftpd.conf

# on redémarre
service proftpd restart


###################
#
# Divers
#
###################

# un peu de beauté dans ce monde de brute
cd
wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
wget http://www.kai23.fr/zshrc
rm .zshrc
mv zshrc .zshrc
chsh -s $(which zsh)




echo "
  					######################
						----------------------

						  Tout est terminé :)

						----------------------
						######################                                                              
"








