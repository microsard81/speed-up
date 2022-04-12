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
echo "\nPlease, specify the device model\n"
echo "================================================================================================"
read -p 'SU model [ 250 | 500 | 1000 ]: ' sumodel
echo "

                        ..::^~~~!!!!!!!!777777777!!~^^:.
                  ..:^^~~^^^::...            ...::^^~!7777!~:.
              .:^^^::.                                  .:^~!777~^.
          .::::.                                              .:~7?7!^.
       .::..                                                       :~7?7~:
     ...                                                              .^!?7~.
                                                                          ^!?7^
  .....      ..     ..     ..      ..     ......           ..       ........:~??~. ::.
 ^~:::^^     ~~     :~.    ^~~:   .~^    .~^:::^^^.       :~~^     .:::~~^::.  :7?7JJ7
.~~:.        ~~     :~.    ^~:~^. .~^    .~^     ^~.     :~:.~^        ^~        :7J?J!
  ::^^^^.    ~~     :~.    ^~  ^~:.~^    .~^     :~:    :~:  .~:       ^~.      .~.:7JJ!
.:.   :!^    ^~:   .~~     ^~.  .^~~^    .~^   .:~^    .~^    :~:      ^~.     .~^   ^?J!
.:^^^^^:      :^^^^^:      :^     :^:    .^^^^^^:.    .^:      :^.     :^      ^^      ~7^
..........................................................................................
..........................................................................................

   AlwaysON Speed Up

------------------------------------------------------------------------------

   Model: SU$sumodel
   Firmware version: 1.0b

   Contact: info@sundata.it

------------------------------------------------------------------------------" > /etc/banner
cd /tmp
rm -fR microsard81-speed-up*
cd $current
echo "================================================================================================"
echo "Customization complete. Please reboot the device"
rm -- "$0"
