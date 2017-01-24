#!/bin/bash
VERSION=0.4.1
ORIGDIR=`pwd`
LOGDIR=`mktemp -d --tmpdir=/tmp oem-XXXXXXXXXX`
EXTRALOG=$LOGDIR"/build-info-log"
touch $EXTRALOG
printf "starting log collector version:$VERSION\n"

cd $LOGDIR
echo "buildstamp:" >> $EXTRALOG
cat /etc/buildstamp >> $EXTRALOG
printf "\nID:\n" >> $EXTRALOG
lspci -x | awk 'NR==4 {print $14 $15 $16 $17}' >> $EXTRALOG
printf "\nhwclock:\n" >> $EXTRALOG
hwclock >> $EXTRALOG
printf "\ndate:\n" >> $EXTRALOG
date >> $EXTRALOG

cp /proc/acpi/wakeup .

lspci -vvnn > ./lspci
lsusb -v > ./lsusb

cp -arf /etc/X11 ./etc-X11
cp -arf /usr/share/X11 ./usr-X11
echo "xrandr -q" >> ./xrandr
xrandr -q >> $EXTRALOG >> ./xrandr
printf "\n\nxrandr --verbose\n" >> ./xrandr
xrandr --verbose >> ./xrandr
xdpyinfo >> ./xdpyinfo.log
glxinfo >> ./glxinfo.log

dmidecode > ./dmidecode

cp -arf /var/log var-log
cp -arf /var/crash var-crash

touch monitors.xml.log
for x in `cd /home/;ls -d *`; do mkdir -p config.d/$x; cp -a /home/$x/.config/monitors.xml* config.d/$x/ 2>> monitors.xml.log; done

touch fwts-results.log
for f in `cd /home/;ls -d *`; do cp -a /home/$f/results.log fwts-$f.log 2>> fwts-results.log; done

dmesg > running_dmesg
cp /proc/cmdline . 
uname -a > running_uname
dpkg -l > debian_packages.txt
ls -laR --full-time > lslR.txt
cp /sys/firmware/acpi/tables/DSDT .
acpidump > acpidump.out 2>/dev/null
ifconfig -a > interfaces.txt
udevadm info --export-db >udevadm.txt

#add 3D info
update-alternatives --display x86_64-linux-gnu_gl_conf > update-alternatives-GL.txt
ldconfig -p | grep GL > ldconfig-p-GL.txt

# find rp partition
RP=`sudo blkid -L HP_TOOLS`
if [ -z ${RP} ]; then
    RP=`sudo blkid -L PQSERVICE`
fi

if [ ! -z ${RP} ]; then
    sudo mount ${RP} /mnt
    [ -f /mnt/bootstrap-buildstamp ] && cp -arf /mnt/bootstrap-buildstamp .
    cp -arf /mnt/boot/grub/grubenv rp-grubenv
    cp -arf /mnt/boot/grub/grub.cfg rp-grub.cfg
    cp -arf /mnt/preseed/project.cfg rp-project.cfg
    sudo umount /mnt
fi

# getting codecs.
for x in `find /proc/asound/ -name codec*` ; do  
   codec_log_fname=${x##*proc\/asound\/};
   codec_log_fname=${codec_log_fname/\//-}
   cat ${x} > $codec_log_fname                             
done

# show partition tables.
blkid > blkid.txt

cd $ORIGDIR
rm -f /tmp/oem-log.tar.gz
tar czvf /tmp/oem-log.tar.gz $LOGDIR 
cp -a /tmp/oem-log.tar.gz .

printf "\n\nPlease attach the oem-log.tar.gz file to the bug report. Thanks.\n"
