#! /bin/sh


# fuer SSH-Tunnel
# echo "$0: shutting down ssh tunnel"
# kill -TERM `cat /tmp/fetchmail-tunnel.$UID.pid`

# fuer stunnel
echo "$0: shutting down stunnel"
kill `cat /var/run/stunnel/stunnel.mail.cs.tu.berlin.de.995.pid `
