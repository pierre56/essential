# Commandes administration Server

## En étant dans le répertoire:
    /home/pentaho/biserver-ce-6.1/biserver-ce/

## Pour éteindre le server
    sudo -u pentaho ./stop-pentaho.sh

## Pour redémarrer le server
    sudo -u pentaho ./start-pentaho.sh


## Dans le cas où le server ne redémarrerait pas
Il est possible qu'il reste encore des processus actifs du server précédemment éteint.

#### 2 étapes pour résoudre cela:

##### 1) trouver le processus qui empêche le démarrage

    netstat -plten |grep java

##### 2) Le tuer

    kill -9 9488
    (-9 for forcely stop and 9488 is process id )
