# Commandes Linux utiles

## Accès aide en ligne
    man [passwd]
    man [ifconfig]

## version de linux
    cat /proc/version
    Linux version 4.4.0-97-generic (buildd@lcy01-33) (gcc version 5.4.0 20160609 (Ubuntu 5.4.0-6ubuntu1~16.04.4) ) #120-Ubuntu SMP Tue Sep 19 17:28:18 UTC 2017

## se déplacer
    cd /home/pentaho/biserver-ce-6.1/biserver-ce/pentaho-solutions/system/common-ui/resources/themes

## pour savoir les droits
    ls -l nomdefichier
    ls -R (pour déplier sous dossier, très utile)

## pour savoir l'appartenance à un groupe
    groups pentaho
    pentaho : pentaho

## pour voir les group
 cat /etc/group | awk -F: '{print $ 1}'

## Rechercher une expression dans un fichier (voir les droits d'un group)
    grep datagadmin /etc/group
    adm:x:4:syslog,netdata,bigeodata,datagadmin
    sudo:x:27:bigeodata,datagadmin

## Ajouter un utilisateur au groupe:
    gpasswd -a <utilisateur> <groupe>

## Supprimer l'utilisateur du groupe :
    gpasswd -d utilisateur groupe

## Récupérer version Java
    java -version

## Récupérer toutes les infos sur la jvm
    java -XX:+PrintFlagsFinal

## Récupérer config lancement Java
    ps -fea|grep -i java

## Récupérer jvm head
    jmap -heap [PID]

## Voir la mémoire libre actuelle
    free -h -t

## Récupérer PID processus
    ps -C java -o pid

## Kill a processus
    kill -9 23947  [kill level PID]

## Démarrer server PENTAHO
    sudo -u pentaho ./start-pentaho.sh

## Eteindre server pentaho
    sudo -u pentaho ./stop-pentaho.sh

## Voir la mémoire + processus
    top

## Voir les dernières connections
    last
