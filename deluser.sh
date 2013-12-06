# /bin/bash
#On commence par vérifier que le script est lancé en tant que root
if [ `whoami` != "root" ]; then
    echo "Vous devez avoir les privilèges super-utilisateur pour exécuter ce script."
    exit 1
fi
clear
dialog --title "Debian SeedBox Installer v1.0" --clear --yesno "Ce script est fait pour supprimer un nouvel utilisateur. Voulez-vous continuer ?" 0 0

if [ $? -eq 1 ]
then
        clear
        exit 1
fi

# On demande un nom d'utilisateur pour la seedbox
data=$(tempfile 2>/dev/null)
trap "rm -f $data" 0 1 2 5 15
dialog --no-cancel --title "Debian SeedBox Installer v1.1" --inputbox "Entrez un login pour le nouvel utilisateur." 0 0 2> $data
user=`cat $data`

# Suppression du groupe
userdel -r $user
rm -Rf /etc/apache2/conf.d/$user
htpasswd -D /etc/apache2/.htpasswd $user
service apache2 restart
