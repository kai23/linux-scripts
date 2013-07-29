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

dialog --title "Debian SeedBox Installer v1.0" --clear --yesno "Ce script est fait pour être exécuté sur une installation Debian vierge.
L'installation prendra environ 20 minutes et se déroulera en plusieurs étapes successives :

- Installation de rTorrent
- Configuration de rTorrent
- Installation de RuTorrent et de ses plugins
- Configuration d'Apache
- Installation de _h5ai
- Installation de MediaInfo
- Configuration du SFTP
- Installation de Oh-My-Zsh

Ce script est fourni tel quel, vous l'utilisez en toute connaissance de cause, à vos risques et périls.

Souhaitez-vous continuer?" 0 0

#On teste le code de retour de dialog pour savoir si l'utilisateur a répondu oui ou non
if [ $? -eq 1 ] 
then 
	clear
	exit 1
fi 

#On demande un login pour la SeedBox
data=$(tempfile 2>/dev/null)
trap "rm -f $data" 0 1 2 5 15
 
dialog --no-cancel --title "Debian SeedBox Installer v1.0" --inputbox "Entrez un login pour votre SeedBox.
(notez-le pour ne pas l'oublier)" 0 0 2> $data
user=`cat $data`

#On demande un mot de passe pour la SeedBox
data=$(tempfile 2>/dev/null)
trap "rm -f $data" 0 1 2 5 15
 
dialog --no-cancel --title "Debian SeedBox Installer v1.0" --passwordbox "Entrez un mot de passe pour votre SeedBox.
Par sécurité le mot de passe ne sera pas affiché, de plus, le mot de passe ne vous sera demandé qu'une fois. Soyez-donc attentif à votre frappe, et notez vôtre mot de passe pour ne pas l'oublier." 0 0 2> $data
htpassword=`cat $data`

#On définit le paramètre de chiffrement de rTorrent
data=$(tempfile 2>/dev/null)
trap "rm -f $data" 0 1 2 5 15

dialog --no-cancel --title "Debian SeedBox Installer v1.0" --menu "Quel type de chiffrement désirez vous?" 0 0 3 1 "Permissif : autoriser les connexions chiffrées entrantes, essayer les connexions chiffrées sortantes." 2 "Normal : autoriser les connexions chiffrées entrantes, forcer les connexions chiffrées sortantes." 3 "Strict : autoriser les connexions chiffrées entrantes, forcer les connexions chiffrées RC4 sortantes." 2> $data

secu=`cat $data`

#On a maintenant tous les paramètres dont nous avons besoin pour installer la SeedBox.
#On peut donc mettre à jour le système et installer les paquets nécessaires.
echo "0" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get update -y > /dev/null
echo "10" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get upgrade -y > /dev/null
echo "30" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y apache2 > /dev/null
echo "31" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y apache2-doc > /dev/null
echo "33" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y apache2-mpm-prefork > /dev/null
echo "34" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y apache2-utils > /dev/null
echo "37" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y libexpat1 > /dev/null
echo "39" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y ssl-cert > /dev/null
echo "40" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y libapache2-mod-php5 > /dev/null
echo "42" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y php5 > /dev/null
echo "43" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y php5-common > /dev/null
echo "46" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y php5-curl > /dev/null
echo "47" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y php5-dev > /dev/null
echo "48" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y php5-gd > /dev/null
echo "50" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y php5-idn > /dev/null
echo "53" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y php-pear > /dev/null
echo "54" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y php5-imagick > /dev/null
echo "55" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y php5-imap > /dev/null
echo "56" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y php5-json > /dev/null
echo "57" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y php5-mcrypt > /dev/null
echo "58" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y php5-memcache > /dev/null
echo "59" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y php5-mhash > /dev/null
echo "60" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y php5-ming > /dev/null
echo "61" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y php5-mysql > /dev/null
echo "62" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y php5-ps > /dev/null
echo "63" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y php5-pspell > /dev/null
echo "64" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y php5-recode > /dev/null
echo "65" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y php5-snmp > /dev/null
echo "66" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y php5-sqlite > /dev/null
echo "67" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y php5-tidy > /dev/null
echo "68" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y php5-xmlrpc > /dev/null
echo "69" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y php5-xsl > /dev/null
echo "70" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y libapache2-mod-scgi > /dev/null
echo "71" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y build-essential > /dev/null
echo "72" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y make > /dev/null
echo "73" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y gcc > /dev/null
echo "74" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y autoconf > /dev/null
echo "75" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y curl > /dev/null
echo "76" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y libcurl3 > /dev/null
echo "77" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y libcurl4-openssl-dev > /dev/null
echo "78" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y zip > /dev/null
echo "79" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y unzip > /dev/null
echo "80" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y gcc > /dev/null
echo "81" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y libc6-dev > /dev/null
echo "82" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y linux-kernel-headers > /dev/null
echo "83" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y diffutils > /dev/null
echo "84" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y wget > /dev/null
echo "85" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y bzip2 > /dev/null
echo "86" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y make > /dev/null
echo "87" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y screen > /dev/null
echo "88" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y ffmpeg > /dev/null
echo "89" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y libcppunit-dev > /dev/null
echo "90" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y libncurses5-dev > /dev/null
echo "91" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y libncursesw5-dev > /dev/null
echo "92" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y subversion > /dev/null
echo "93" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y libsigc++ > /dev/null
echo "94" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y imagemagick > /dev/null
echo "96" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y zsh > /dev/null
echo "97" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y git > /dev/null
echo "98" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y openssl > /dev/null
echo "99" | dialog --no-cancel --gauge "Mise à jour du système et installation des paquets nécessaires. Veuillez patienter." 0 0
apt-get install -y unrar-free > /dev/null


#Installation de rTorrent
clear
echo "







#############################
#                           #
# Configuration de rTorrent #
#                           #
#############################


"

# Retour à la maison !
cd

# Soyons propres
mkdir sources
cd sources

#On récupère tout
svn co https://xmlrpc-c.svn.sourceforge.net/svnroot/xmlrpc-c/advanced/ xmlrpc-c
wget http://libtorrent.rakshasa.no/downloads/libtorrent-0.13.2.tar.gz
wget http://libtorrent.rakshasa.no/downloads/rtorrent-0.9.2.tar.gz

#On extrait !
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

#On nettoie
cd
rm -Rf sources

#Y'a parfois une petite erreur avec la librairie 
ldconfig

clear
echo "






#############################
#                           #
# Configuration de rTorrent #
#                           #
#############################


"

# Création du groupe et de l'utilisateur qui executera rtorrent
echo "$user:$htpassword:4242:4242:$user,,,:/home/$user:/bin/bash" | newusers

# Création des repertoires de fonctionnement de rtorrent
# on créé un lien symbolique vers le répertoire de téléchargement dans la racine www
mkdir /home/$user/downloads
mkdir /home/$user/watch
mkdir /home/$user/.session
ln -s /home/$user/downloads /var/www/downloads
chown www-data:www-data /var/www/downloads
chown -R $user:$user /home/$user

# On limite l'accès aux dossiers rtorrent à l'utilisateur rtorrent seul.
chmod -R 755 /home/$user/downloads/
chmod -R 711 /home/$user/.session

#On écrit le fichier de configuration .rtorrent.rc en fonction du paramètre de chiffrement obtenu plus haut.
if [ $secu -eq 1 ] 
then 
	echo "directory = /home/$user/downloads
session = /home/$user/.session
port_range = 6890-6999
port_random = yes
check_hash = no
use_udp_trackers = yes
schedule = watch_directory,15,15,load_start=/home/$user/watch/*.torrent
schedule = untied_directory,5,5,stop_untied= 
dht = disable
peer_exchange = no
scgi_port = 127.0.0.1:5000
ip = 127.0.0.1
encryption = allow_incoming,try_outgoing" > /home/$user/.rtorrent.rc
fi 

if [ $secu -eq 2 ] 
then 
	echo "directory = /home/$user/downloads
session = /home/$user/.session
port_range = 6890-6999
port_random = yes
check_hash = no
use_udp_trackers = yes
schedule = watch_directory,15,15,load_start=/home/$user/watch/*.torrent
schedule = untied_directory,5,5,stop_untied= 
dht = disable
peer_exchange = no
scgi_port = 127.0.0.1:5000
ip = 127.0.0.1
encryption = allow_incoming,require" > /home/$user/.rtorrent.rc
fi 

if [ $secu -eq 3 ] 
then 
	echo "directory = /home/$user/downloads
session = /home/$user/.session
port_range = 6890-6999
port_random = yes
check_hash = no
use_udp_trackers = yes
schedule = watch_directory,15,15,load_start=/home/$user/watch/*.torrent
schedule = untied_directory,5,5,stop_untied= 
dht = disable
peer_exchange = no
scgi_port = 127.0.0.1:5000
ip = 127.0.0.1
encryption = allow_incoming,require_RC4" > /home/$user/.rtorrent.rc
fi 



# On lance rTorrent en arrière plan
killall rtorrent 2> /dev/null
su $user -c "screen -fn -dmS rtd nice -19 rtorrent"



clear
echo "







###############################################
#                                             #
# Installation de RuTorrent et de ses plugins #
#                                             #
###############################################


"

cd /var/www
svn checkout http://rutorrent.googlecode.com/svn/trunk/rutorrent/
cd rutorrent
rm -R plugins
svn checkout http://rutorrent.googlecode.com/svn/trunk/plugins/
chown -R www-data:www-data /var/www

clear
echo "







##########################
#                        #
# Configuration d'Apache #
#                        #
##########################


"

#Arrêt du serveur Apache
service apache2 stop

#Génération du .htpasswd que nous placons dans le dossier etc/apache2, à l'abri.
htpasswd -mbc /etc/apache2/.htpasswd $user $htpassword

#Génération des clés de chiffrement
cd /etc/ssl/certs/

echo "
#Creation d'un fichier mot de passe.

"
echo 6ec728db6df7 > .passwd
 
echo "
#Génération de notre propre autorité de certification.

"
openssl genrsa -des3 -out ca.key -passout file:.passwd 4096 
openssl req -passin file:.passwd -new -x509 -days 3650 -key ca.key -out ca.crt \
  -subj "/C=FR/ST=IDF/L=PARIS/O=TNT/OU=PRE-PROD/CN=www-pp.tnt.fr"

echo "
#Génération d'une clé serveur et demande de signature.

"
openssl genrsa -passout file:.passwd -des3 -out server.key 4096
openssl req -new -key server.key -out server.csr -passin file:.passwd \
  -subj "/C=FR/ST=IDF/L=PARIS/O=toto/OU=PRE-PROD/CN=kim.su.fi"
 
echo "
#Signature du certificat avec l'autorité créée précédemment.

"
openssl x509 -passin file:.passwd -req -days 3650 -in server.csr \
  -CA ca.crt -CAkey ca.key -set_serial 01 -out server.crt

echo "
#Faire un fichier server.key qui n'implique pas une demande de mot de passe d'Apache.

"
openssl rsa -passin file:.passwd -in server.key -out server.key.insecure

echo "
#Échange des clés.

"
mv server.key server.key.secure
mv server.key.insecure server.key

chmod 400 server.*
chmod 400 .passwd


# Écriture de la configuration Apache
IP=`ifconfig eth0 | grep "inet ad" | cut -f2 -d: | awk '{print $1}'`

echo "#Configuration du module SCGI pour la synchro rTorrent/Rutorrent
SCGIMount /RPC2 127.0.0.1:5000
ServerName http://$IP/

#Redirection http > https
<VirtualHost $IP:80>
        ServerAdmin admin@kim.sufi
        DocumentRoot /var/www/
        ServerName http://$IP/
        Redirect permanent / https://$IP/
</VirtualHost>

#SSL
<IfModule mod_ssl.c>
<VirtualHost $IP:443>

        ServerAdmin admin@kim.sufi
        DocumentRoot /var/www
        ServerName https://$IP

        <Directory />
                Options FollowSymLinks
                AllowOverride None
        </Directory>

        <Directory /var/www/>
                Options FollowSymLinks ExecCGI
                AllowOverride All
                Order allow,deny
                allow from All
        </Directory>

        ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/
        <Directory \"/usr/lib/cgi-bin\">
                AllowOverride None
                Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch
                Order allow,deny
                Allow from all
        </Directory>

        ErrorLog \${APACHE_LOG_DIR}/error.log

        # Possible values include: debug, info, notice, warn, error, crit,
        # alert, emerg.
        LogLevel warn

        CustomLog \${APACHE_LOG_DIR}/ssl_access.log combined

        #   Enable/Disable SSL for this virtual host.
        SSLEngine on
                SSLCertificateFile /etc/ssl/certs/server.crt
                SSLCertificateKeyFile /etc/ssl/certs/server.key

        <FilesMatch \"\.(cgi|shtml|phtml|php)$\">
                SSLOptions +StdEnvVars
        </FilesMatch>
        <Directory /usr/lib/cgi-bin>
                SSLOptions +StdEnvVars
        </Directory>
        BrowserMatch \"MSIE [2-6]\" \
                nokeepalive ssl-unclean-shutdown \
                downgrade-1.0 force-response-1.0
        # MSIE 7 and newer should be able to use keepalive
        BrowserMatch \"MSIE [7-9]\" ssl-unclean-shutdown
        <Directory /var/www>
                Options All
                AllowOverride All
                AuthName \"Private\"
                AuthType Basic
                AuthUserFile /etc/apache2/.htpasswd
                Require user $user
                Order allow,deny
                Allow from All
        </Directory>
        <Directory /var/www/downloads>
                Options All
                AllowOverride All
                AuthName \"Private\"
                AuthType Basic
                AuthUserFile /etc/apache2/.htpasswd
                Require user $user
                Order allow,deny
                Allow from All
        </Directory>
</VirtualHost>
</IfModule>
DirectoryIndex  index.html  index.php  /_h5ai/server/php/index.php" > /etc/apache2/conf.d/$user

#Activation des différents modules Apache
a2enmod rewrite
a2enmod ssl
a2enmod auth_digest
a2enmod scgi

#Redémarrage d'Apache
service apache2 start



echo "







#########################
#                       #
# Installation de _h5ai #
#                       #
#########################


"

cd /var/www/
wget http://release.larsjung.de/h5ai/h5ai-0.23.0.zip
unzip h5ai-0.23.0.zip
rmh5ai-0.23.0.zip
rm index.html 


echo "







#############################
#                           #
# Installation de Mediainfo #
#                           #
#############################


"

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


echo "







##########################
#                        #
#  Configuration du SFTP #
#                        #
##########################


"
#On change la configuration du daemon ssh

#On empêche la connexion root, il faudra se connecter avec un
#utilisateur normal et obtenir les privilèges par la suite. (su / sudo)
sed 's/PermitRootLogin/#PermitRootLogin/' /etc/ssh/sshd_config

#On désactive le Subsystem sftp de base pour passer au Subsystem interne
sed 's/Subsystem/#Subsystem/' /etc/ssh/sshd_config
echo "
PermitRootLogin no
#SFTP
Subsystem sftp internal-sftp

Match Group $user   
    ChrootDirectory /downloads
    ForceCommand internal-sftp
    X11Forwarding no
    AllowTcpForwarding no" >> /etc/ssh/sshd_config

#On crée un lien symbolique pour pouvoir chrooter l'utilisateur
#dans le dossier Downloads de rtorrent
ln -s /home/$user/downloads /downloads

#Puis on redémarre le démon ssh
service ssh restart

echo "







#############################
#                           #
# Installation de Oh-My-ZSH #
#                           #
#############################


"

#Un peu de beauté dans ce monde de brute
cd
wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
wget http://www.kai23.fr/zshrc
rm .zshrc
mv zshrc .zshrc
chsh -s $(which zsh)


dialog --title "Debian SeedBox v1.0" --infobox "Pour accéder à votre Seedbox : http://$IP/
Votre login est : $user
Votre mot de passe est celui donné en début d'installation, j'espère que vous l'avez noté.

Paramètres FTP :
-Hôte : $IP
-Port : 22
-Protocole : SFTP (SSH File Transfert Protocol)
-Type d'authentification : Normale
-Identifiant : $user
-Mot de passe : Je vous laisse deviner.

Les certificats de chiffrement étant autosignés, certains navigateurs vous offriront probablement des avertissements de sécurité. Ignorez-les après avoir vérifié l'url dans la barre d'adresse. De plus, la connexion ssh pour root est désactivée par sécurité, vous pouvez vous connecter avec votre login et votre mot de passe, puis passer root avec la commande su.

######################
----------------------
 Tout est terminé :)
----------------------
######################" 0 0
