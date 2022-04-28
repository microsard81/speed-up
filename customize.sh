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
echo "------------------------------------------------------------------------------------------------"
echo "================================================================================================"
echo " "
echo "Please, specify the device model"
echo " "
echo "================================================================================================"
read -p 'SU model [ 250 | 500 | 1000 ]: ' sumodel
read -p 'SU S/N: ' sn
echo " "
echo "

  ____    _   _   _   _   ____       _      _____      _    
 / ___|  | | | | | \ | | |  _ \     / \    |_   _|    / \   
 \___ \  | | | | |  \| | | | | |   / _ \     | |     / _ \  
  ___) | | |_| | | |\  | | |_| |  / ___ \    | |    / ___ \ 
 |____/   \___/  |_| \_| |____/  /_/   \_\   |_|   /_/   \_\
                                                            
          _    _                          ___  _   _ 
        / \  | |_      ____ _ _   _ ___ / _ \| \ | |
       / _ \ | \ \ /\ / / _` | | | / __| | | |  \| |
      / ___ \| |\ V  V / (_| | |_| \__ \ |_| | |\  |
     /_/   \_\_| \_/\_/ \__,_|\__, |___/\___/|_| \_|
                              |___/                 

------------------------------------------------------------------------------

   Model: SU$sumodel
   S/N: $sn
   Firmware version: 1.0b

   Contact: info@sundata.it

------------------------------------------------------------------------------

" > /etc/banner
cd /tmp
rm -fR microsard81-speed-up*
cd /etc/dropbear
rm -f dropbear_ed25519_host_key
rm -f dropbear_rsa_host_key
dropbearkey -f dropbear_ed25519_host_key -t ed25519
dropbearkey -f dropbear_rsa_host_key -t rsa -s 2048
cd $current
echo "================================================================================================"
echo "Customization complete. Please reboot the device"
echo " "
rm -- "$0"
