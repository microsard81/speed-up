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

echo "Installazione Zabbix Agent su $HOSTNAME..."

# 1. Scarica e installa il binario statico
wget https://cdn.zabbix.com/zabbix/binaries/stable/7.0/7.0.22/zabbix_agent-7.0.22-linux-3.0-amd64-static.tar.gz -O /tmp/zabbix.tar.gz
tar -xzf /tmp/zabbix.tar.gz -C /tmp/
cp /tmp/sbin/zabbix_agentd /usr/sbin/
rm /tmp/zabbix.tar.gz

# 2. Crea le directory necessarie e la conf
mkdir -p /etc/zabbix /etc/zabbix_agentd.conf.d /tmp/run/zabbix /tmp/log/zabbix

cat << EOF > /etc/zabbix/zabbix_agentd.conf
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
UserParameter=wan.provider.ip[*],uci get openmptcprouter.\$1.local_ipv4
UserParameter=lan.ipandmask,echo \`uci get network.lan.ipaddr\`/\`uci get network.lan.netmask\`
UserParameter=lan.ip,echo \`uci get network.lan.ipaddr\`
UserParameter=lan.mask,echo \`uci get network.lan.netmask\`
EOF

chmod +x /etc/zabbix_agentd.conf.d/alwayson

# 3. Servizio procd
cat > /etc/init.d/zabbix-agentd << 'EOF'
#!/bin/sh /etc/rc.common

START=99
STOP=10
USE_PROCD=1

start_service() {
    mkdir -p /tmp/run/zabbix /tmp/log/zabbix
    procd_open_instance
    procd_set_param command /usr/sbin/zabbix_agentd -c /etc/zabbix/zabbix_agentd.conf -f
    procd_set_param respawn
    procd_set_param stdout 1
    procd_set_param stderr 1
    procd_close_instance
}
EOF

chmod +x /etc/init.d/zabbix-agentd

# 4. Avvio
/etc/init.d/zabbix-agentd enable
/etc/init.d/zabbix-agentd start
sleep 2

if ps | grep -v grep | grep -q zabbix_agentd; then
    echo "Zabbix Agent avviato correttamente su $HOSTNAME"
else
    echo "ERRORE: Zabbix Agent non avviato. Controlla con: logread | grep zabbix"
fi


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
