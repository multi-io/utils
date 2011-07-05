#! /bin/sh

set -e

# SSH-Tunnel
# echo "$0: setting up ssh tunnel from localhost:8011 to mail.cs.tu-berlin.de:110"
# ssh -L 8011:mail.cs.tu-berlin.de:110 basta.cs.tu-berlin.de sleep 1000000 &
# echo $! >/tmp/fetchmail-tunnel.$UID.pid
# echo "$0: sleeping 15 secs, waiting for SSH to set up the tunnel"
# echo "$0: TODO: this is a race condition"
# # TODO: tja... wie teilt der laufende ssh-Prozess nach auﬂen mit, dass
# #       die Verbindung hergestellt wurde? Shellscripting saugt!
# sleep 15;

# mit SSL
# Zur stunnel-Installation (as root): chgrp users /var/run/stunnel; chmod g+rwx /var/run/stunnel
echo "$0: setting up stunnel from localhost:8011 to mail.cs.tu-berlin.de POP3 service"
/usr/bin/stunnel -c -d localhost:8011 -r mail.cs.tu-berlin.de:995 -v 3 -A "`dirname $0`/mail.cs.tu-berlin.de.cert" -P /var/run/stunnel/
echo "$0: sleeping 3 secs, waiting for stunnel to set up the tunnel"
sleep 3;

echo "$0: done"
