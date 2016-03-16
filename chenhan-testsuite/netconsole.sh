sudo sh -c 'echo netconsole >> /etc/modules'
sudo sh -c 'echo options netconsole netconsole=6666@10.101.46.180/eth0,6666@10.101.46.215/9c:d2:1e:d5:4a:01 > /etc/modprobe.d/netconsole.conf'
