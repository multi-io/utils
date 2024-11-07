X11LDFLAGS=-L/usr/X11R6/lib -lX11

GLOBALFILES=\
a2xcf \
apt-list-contents \
apt-build \
audioreset \
blackscrn.pl \
cdburn \
cdburn-rr \
dvdburn \
dvdburn-rr \
dvdvideoburn \
cdcopy.sh \
cdcopy_onthefly.sh \
cddaenc.sh \
cddamv.pl \
cddarip.sh \
cdda-cddbrip \
cdisoburn \
create-imgs-ovwpage \
create-index-htmls \
cutv \
deb-import-signing-key \
docker-reclaimspace.sh \
emacs_or_fallback.sh \
get_wan_ip \
gtetrinet-configure-keyboard \
gtetrinet-unconfigure-keyboard \
gitc \
git-append-repo \
gnuplot-and-wait \
gnuplot-eps \
gnuplot-eps-and-wait \
gnuplot-png \
jolietrename \
jolietrenamecurrdir \
jolietnamecheckcurrdir \
chr \
chrcodes \
cpmydir.sh \
cvs-add-subtree-dirs \
cvs-add-subtree-files \
cvs-isstssh \
cvs-myissthostssh \
cvslog2kwsubst \
cvsshowunkn.pl \
deb-fetch-uris \
deb-list-pkgs \
deb-sourceslist-change-debhost \
deb-xtract-uris \
disk2file.sh \
dos2unixm.sh \
e \
eardiff.sh \
edit-encrypted \
eol2nul \
execlogged \
fetchheise-fetcharticles \
fetchheise-idxpage-fetchallarticles \
fetchheise-idxpage-idxpageurls \
fetchheise-idxpage-all-articleurls \
fetchheise-idxpages-articleurls \
fetchmail-setup-tunnel.sh \
firefox-print-stacktraces \
firefox-print-stacktraces.gdbscript \
fetchmail-shutdown-tunnel.sh \
file2disk.sh \
fzf-prjdir \
Linux/file-cached-blocks \
fsumup \
fullpath \
gal2nsbm.py \
generate-site-specific-filenames \
getcdrdev \
getdvdrdev \
getpid \
gianasis \
grepre \
grep_instfiles \
homebrew-collect-gnubins \
ifaceaddr \
imagej \
install-javaplugin \
instfilelist.pl \
ip6to4 \
irexec.pl \
iriver2m3ufile.pl \
jsonpp \
json_pp_perline \
kill-flashplugin \
kill-vpn.sh \
kube-serviceaccount-kubeconfig \
kube-node-extip \
kube-pod-node \
kube-pod-kill-container \
kubectl-switch-ns \
kubectl-get-ns \
locateme \
libusers \
linehist \
listexecs \
listfrom \
listto \
lnum.sh \
log-pcap \
log-pcap-transferrate \
log-transferrate \
make-my_configure_help \
m3u2iriver.pl \
m3u2iriverfile.pl \
m3uxmms2unx \
maestro \
mysqldump-split \
mv2unique \
Linux/memeaters.pl \
Linux/memeaters1.pl \
Linux/memusage \
Linux/memusage-log-for-pid \
Linux/memusage-snapshot \
Linux/memusage_for_pid_by_lib \
Darwin/memusage-snapshot \
Darwin/memusage-snapshot-full \
mlnet-disksize-watchdog \
mouseclick \
mplayerctl \
mplayer-ctlable \
mplayer-dump-latest \
mygdb \
myhexdump \
palm-fetchheise \
pidof \
prepend-time \
pslibs.pl \
quotelines \
rfcidx.pl \
rminst \
run-if-not-running.sh \
scp-myissthost \
sensible-browser \
settimefromntp \
show-encrypted \
slowdown.pl \
sumsizes \
sumup \
syncmp3s \
thermal-snapshot \
timedrun.sh \
timelogger.pl \
track-in-pushgw \
unique-lines \
unpacksrcrpm.sh \
unzip2d \
update_cookiestxts \
vcr-chilitv \
vcr-daily \
videnc \
videnc.sh \
wait4time \
wgetheise.sh \
wget-completepage \
wget-withbrowsersettings \
xmms2iriver \
zipdir.sh \
stopwatch \
showargs \
jython2bsh \
mountdata \
umountdata \
freemind \
export-sawfish \
perl-e-perline \
perl-e-perline-inplace \
psfindbywd \
py2json \
rspeedway \
ruby-e-perline \
show-spurious-listeners \
spurious-listeners-watchdog \
scp-ignorehostkey \
ssh-ignorehostkey \
svnshowunkn \
tvbrowser \
wget-logging \
xless \
xmule-continuously \
xscreensaver-keepaway \
xterm-fullscreen \
xy+-plot \
xy+-average \
xy+-derive \
y+-average \
y+-derive \
xypairs-derive \
xypairs-average \
y+-plot \
youtubedown \
myhomedesktop/emacs_or_fallback.sh \
make-misc \
misc.make \
lesscat \
strace-all \
tmux-session \
tmux-session-switch \
tmux-session-mk-branch \
zipjavasources

#GLOBALTARGET=$(HOME)/bin
GLOBALTARGET=/usr/local/bin

SUCOMMAND=su root

SBINFILES=\
memusagelogd \
publish_aliceip_to_dns_continuously \
thermallogd \
transferratelogd \
run-ppp-over-ssh \
mysofdhost/run-sofdsshvpn \
mysofdhost/run-sofdsshvpn-continuously \
myhomehost/backup-tick-to \
myhomehost/backup-tick-to-bup1 \
myhomehost/kill-vpn-continuously \
myhomehost/reinit-network \
myhomehost/sofdsshvpn-routes \
myhomehost/setup-6to4 \
myhomehost/shutdown-6to4 \
myhomehost/wlan-scan \
myhomehost/wlan-switch-to-ap \
myhomehost/wlan-switch-to-sta \
myhomehost/wlan-restartap \
myhomedesktop/remount-backup1 \
myhomedesktop/setup-6to4 \
myhomedesktop/shutdown-6to4 \
mylaptop/wlan-reinit

SBINTARGET=/usr/local/sbin

USERFILES=\
firefox-memusage-log-create.sh \
firefox-memusage-log-plot.sh \
irexec.pl \
list-olafs-xauth \
ssh-forward-allisst \
ssh-forward-allisst-continuously \
ssh-forward-isstcvs \
ssh-forward-isstica \
ssh-forward-isstssh \
ssh-forward-isstwww \
ssh-forward-myissthostssh \
ssh-forwarded-isstssh \
ssh-forwarded-myissthost \
ssh-isstunixhost \
ssh-myissthost \
xmms.sh

USERTARGET=$(HOME)/bin

default: install

install: install-global install-user

TMP=/tmp/mkinstglobal-$(USER)

include Makefile.conf

# TODO: race condition?
install-global: $(GLOBALFILES)
	mkdir -p $(GLOBALTARGET)
	mkdir -p $(SBINTARGET)
	rm -f $(TMP); umask 022; echo '#!/bin/sh' >$(TMP)
	$(foreach file,$(GLOBALFILES), echo mkdir -p '$(GLOBALTARGET)'/`dirname $(file)` >>$(TMP); \
				       echo install $(file) '$(GLOBALTARGET)'/`dirname $(file)` >>$(TMP);)
	$(foreach file,$(SBINFILES), echo mkdir -p '$(SBINTARGET)'/`dirname $(file)` >>$(TMP); \
				       echo install $(file) '$(SBINTARGET)'/`dirname $(file)` >>$(TMP);)
	chmod +x $(TMP)
	$(SUCOMMAND) $(TMP)
	rm -f $(TMP)


install-user: $(USERFILES)
	mkdir -p $(USERTARGET)
	$(foreach file,$(USERFILES), mkdir -p '$(USERTARGET)'/`dirname $(file)`; \
				     install $(file) '$(USERTARGET)'/`dirname $(file)`;)


%: %.c
	$(CC) $(CFLAGS) $(X11LDFLAGS) -o $@ $< || (echo "WARNING: compiling $@ failed, creating it as a fake stub"; (echo "#!/bin/sh"; echo "echo '$@ could not be compiled at utils make time (no cc)'") >$@)

log-pcap:  log-pcap.d/log-pcap
	cp $< $@

log-pcap.d/log-pcap: log-pcap.d/main.c
	$(MAKE) -C log-pcap.d log-pcap || (echo "WARNING: compiling $@ failed, creating it as a fake stub"; (echo "#!/bin/sh"; echo "echo '$@ could not be compiled at utils make time'") >$@)



