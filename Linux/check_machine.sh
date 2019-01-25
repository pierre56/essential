#!/usr/bin/env bash

echo ""
echo "--- Version de l'OS"
lsb_release -a

OSCODENAME=$(lsb_release -c -s)


echo ""
echo "--- Nombre de processeurs"

cat /proc/cpuinfo | grep "model name"

echo ""
echo "--- Mémoire libre"
free -h

echo ""
echo "--- Occupation disques"
df -h

echo ""
echo "---- réseau"

command -v ifconfig
if [ $? -ne 1 ]; then
    # Vérifier l'IP locale (Debian < 9 our Ubuntu < 18.04)
    ifconfig
else
    # Pour Ubuntu >= 18.04 ou Debian >= 9
    ip address
fi
