#!/bin/sh

echo "Installazione Zabbix Agent su $HOSTNAME..."

# 1. Scarica e installa il binario statico
wget https://cdn.zabbix.com/zabbix/binaries/stable/7.0/7.0.22/zabbix_agent-7.0.22-linux-3.0-amd64-static.tar.gz -O /tmp/zabbix.tar.gz
tar -xzf /tmp/zabbix.tar.gz -C /tmp/
cp /tmp/sbin/zabbix_agentd /usr/sbin/
rm /tmp/zabbix.tar.gz

# 2. Crea le directory necessarie
mkdir -p /etc/zabbix /etc/zabbix_agentd.conf.d /tmp/run/zabbix /tmp/log/zabbix

# 3. Configurazione
mv /etc/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf

# 4. Servizio procd
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

# 5. Avvio
/etc/init.d/zabbix-agentd enable
/etc/init.d/zabbix-agentd start
sleep 2

if ps | grep -v grep | grep -q zabbix_agentd; then
    echo "Zabbix Agent avviato correttamente su $HOSTNAME"
else
    echo "ERRORE: Zabbix Agent non avviato. Controlla con: logread | grep zabbix"
fi
