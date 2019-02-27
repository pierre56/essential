# Commandes Linux utiles


# Linux

### Modifier clavier azerty/qwerty

    setxkbmap fr
    loadkeys fr

### Accès aide en ligne
    man [passwd]
    man [ifconfig]

### version de linux
    uname -a

    cat /proc/version
    Linux version 4.4.0-97-generic (buildd@lcy01-33) (gcc version 5.4.0 20160609 (Ubuntu 5.4.0-6ubuntu1~16.04.4) ) #120-Ubuntu SMP Tue Sep 19 17:28:18 UTC 2017

    dmesg | grep Linux  

### se déplacer
    cd /home/pentaho/biserver-ce-6.1/biserver-ce

## Disk
    parted
    sfdisk
    lsblk


---------
# User, Droits et Permissions

## User

### Passer root
    sudo -i

### Ajouter un utilisateur
    adduser vps_temp


### Savoir quel compte j'utilise
    whoami

---------
## Droits

### pour savoir les droits
    ls -l nomdefichier
    ls -R (pour déplier sous dossier, très utile)



---------

## Group

### pour savoir l'appartenance à un groupe
    groups pentaho
    pentaho : pentaho

### pour voir les group
    cat /etc/group | awk -F: '{print $ 1}'

### Rechercher une expression dans un fichier (voir les droits d'un group)
    grep datagadmin /etc/group
    adm:x:4:syslog,netdata,bigeodata,datagadmin
    sudo:x:27:bigeodata,datagadmin


### Ajouter un utilisateur au groupe:
    gpasswd -a <utilisateur> <groupe>

### Supprimer l'utilisateur du groupe :
    gpasswd -d <utilisateur> <groupe>



---------
# Pentaho

## Gestion server PENTAHO

### Démarrer server PENTAHO
    sudo -u pentaho ./start-pentaho.sh

### Eteindre server pentaho
    sudo -u pentaho ./stop-pentaho.sh

### Dans le cas où le server ne redémarrerait pas
Il est possible qu'il reste encore des processus actifs du server précédemment éteint.

#### 2 étapes pour résoudre cela:

##### 1) trouver le processus qui empêche le démarrage

    sudo netstat -plten |grep java

##### 2) Le tuer

    kill -9 9488
    (-9 for forcely stop and 9488 is process id )

---------
## Mémoire

### Voir la mémoire libre actuelle
    free -h -t

### Voir la mémoire + processus
    top

---------
## Java

### Récupérer version Java
    java -version

### Récupérer toutes les infos sur la jvm
    java -XX:+PrintFlagsFinal

### Récupérer config lancement Java
    ps -fea|grep -i java

### Récupérer jvm head
    jmap -heap [PID]


### Récupérer PID processus
    ps -C java -o pid

### Kill a processus
    kill -9 23947  [kill level PID]

---------
# Connection

### Voir les dernières connections
    last => last connections
    lasb => bad connections

#### Se connecter en SSH (avec cmder)
    ssh user@host

#### Se déconnecter en SSH (avec cmder)
    exit

---------
