#!/bin/sh
#

current=`pwd`
cd /tmp
wget -O repo.tar.gz https://api.github.com/repos/microsard81/speed-up/tarball
tar x -zv -f repo.tar.gz
rm -f repo.tar.gz 
cd microsard81-speed-up*
cp -R luci-static/argon /www/luci-static/.
cp -R themes/argon /usr/lib/lua/luci/view/themes/.
cp resources/* /www/luci-static/resources/.
sed -i "844 i \ \t\t\tvar back = svg.getElementById('backgound_modem_1');" /usr/lib/lua/luci/view/openmptcprouter/wanstatus.htm
sed -i "845 i \ \t\t\tback.setAttribute('style', 'fill: ' + color + ';fill-opacity:0.6;');" /usr/lib/lua/luci/view/openmptcprouter/wanstatus.htm
sed -i "846 i \ \t\t\tvar back = svg.getElementById('backgound_modem_2');" /usr/lib/lua/luci/view/openmptcprouter/wanstatus.htm
sed -i "847 i \ \t\t\tback.setAttribute('style', 'fill: ' + color + ';fill-opacity:0.6;');" /usr/lib/lua/luci/view/openmptcprouter/wanstatus.htm
echo "------------------------------------------------------------------------------------------------"
echo "================================================================================================"
echo " "
echo "Please, specify the device details"
echo " "
echo "================================================================================================"
read -p 'SU model [ 250 | 500 | 1000 ]: ' sumodel
read -p 'SU Serial Number: ' sn
read -p 'SU hostname: ' host
read -p 'SU Zabbix hostname: ' zabbix
echo " "
uci set system.@system[0].hostname=$host
uci commit system
echo " 

  #####   #     #  #     #  ######      #     #######     #
 #     #  #     #  ##    #  #     #    # #       #       # #
 #        #     #  # #   #  #     #   #   #      #      #   #
  #####   #     #  #  #  #  #     #  #     #     #     #     #
       #  #     #  #   # #  #     #  #######     #     #######
 #     #  #     #  #    ##  #     #  #     #     #     #     #
  #####    #####   #     #  ######   #     #     #     #     #


------------------------------------------------------------------------------

   ALWAYS ON
   
------------------------------------------------------------------------------

   Model: SU$sumodel
   Serial Number: $sn
   Firmware version: 1.0b

   Contact: info@sundata.it

------------------------------------------------------------------------------

" > /etc/banner
cd /tmp/microsard81-speed-up*
opkg update ; opkg install rsyslog zabbix-agentd zabbix-extra-mac80211 zabbix-extra-network zabbix-extra-wifi python3-speedtest-cli
cp -f rsyslog.conf /etc/.

mv /etc/zabbix_agentd.conf /etc/zabbix_agentd.conf.bak
cat << EOF > /etc/zabbix_agentd.conf
LogType=system
AllowRoot=1
Server=82.191.45.246
StartAgents=1
ServerActive=82.191.45.246
Hostname=$zabbix
Include=/etc/zabbix_agentd.conf.d/
UserParameter=devicetype,AlwaysOnSpeedUp-Router
UserParameter=serialnumber,echo "$sn"
HostMetadataItem=devicetype
EOF

cat << EOF > /etc/zabbix_agentd.conf.d/alwayson
UserParameter=wan.discovery,wandiscovery
UserParameter=wan.status[*],wanstatus \$1
UserParameter=wan.ip,curl -s ipinfo.io/ip
UserParameter=wan.label[*],uci get network.\$1.label
UserParameter=wan.provider.ip[*],uci get openmptcprouter.\$1.publicip
UserParameter=lan.ipandmask,echo \`uci get network.lan.ipaddr\`/\`uci get network.lan.netmask\`
UserParameter=lan.ip,echo \`uci get network.lan.ipaddr\`
UserParameter=lan.mask,echo \`uci get network.lan.netmask\`
EOF

chmod +x /etc/zabbix_agentd.conf.d/alwayson
cp wanstatus /bin/.
cp wandiscovery /bin/.
cp getspeed /bin/.
chmod +x /bin/wanstatus
chmod +x /bin/wandiscovery
chmod +x /bin/getspeed
cd /tmp
rm -fR microsard81-speed-up*
cd /etc/dropbear
rm -f dropbear_ed25519_host_key
rm -f dropbear_rsa_host_key
dropbearkey -f dropbear_ed25519_host_key -t ed25519
dropbearkey -f dropbear_rsa_host_key -t rsa -s 2048
cd $current
echo "/etc/zabbix_agentd.conf.d/" >> /etc/sysupgrade.conf
echo "/etc/ssl/private/" >> /etc/sysupgrade.conf
/etc/ssl/private/
echo "================================================================================================"
echo "Customization complete. Please reboot the device"
echo " "
rm -- "$0"
