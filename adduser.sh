# /bin/bash

#On commence par vérifier que le script est lancé en tant que root
if [ `whoami` != "root" ]; then
    echo "Vous devez avoir les privilèges super-utilisateur pour exécuter ce script."
    exit 1
fi

#On installe dialog pour afficher les messages
clear
dialog --title "Debian SeedBox Installer v1.0" --clear --yesno "Ce script est fait pour ajouter un nouvel utilisateur" 0 0

if [ $? -eq 1 ]
then
        clear
        exit 1
fi
firstUser=`awk -F: '/^audio/ {print $4;}' /etc/group`

# On demande un nom d'utilisateur pour la seedbox
data=$(tempfile 2>/dev/null)
trap "rm -f $data" 0 1 2 5 15
dialog --no-cancel --title "Debian SeedBox Installer v1.1" --inputbox "Entrez un login pour le nouvel utilisateur." 0 0 2> $data
user=`cat $data`

# On demande un mot de passe
data=$(tempfile 2>/dev/null)
trap "rm -f $data" 0 1 2 5 15

dialog --no-cancel --title "Debian SeedBox Installer v1.0" --passwordbox "Entrez un mot de passe pour votre utilisateur. Celui-ci ne sera pas affiche, notez-le bien !" 0 0 2> $data
htpassword=`cat $data`

# Création du groupe et de l'utilisateur qui executera rtorrent
echo "$user:$htpassword:4242:4242:$user,,,:/home/$user:/bin/bash" | newusers

mkdir /home/$user/watch
mkdir /home/$user/.session
ln -s /var/www/downloads /home/$user/
chown -R $user:$user /home/$user

chmod -R 755 /home/$user/downloads/
chmod -R 711 /home/$user/.session

htpasswd -mb /etc/apache2/.htpasswd $user $htpassword


# ériture de la configuration Apache
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
                Require valid-user
                Order allow,deny
                Allow from All
        </Directory>
        <Directory /var/www/downloads>
                Options All
                AllowOverride All
                AuthName \"Private\"
                AuthType Basic
                AuthUserFile /etc/apache2/.htpasswd
                Require valid-user
                Order allow,deny
                Allow from All
        </Directory>
</VirtualHost>
</IfModule>
DirectoryIndex  index.html  index.php  /_h5ai/server/php/index.php" > /etc/apache2/conf.d/$firstUser

service apache2 restart

dialog --title "Debian SeedBox v1.0" --infobox "Votre login est : $user
######################
----------------------
 Tout est terminé©)
----------------------
######################" 0 0
