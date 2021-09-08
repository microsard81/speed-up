#!/bin/sh
#

cd /tmp

wget -O repo.tar.gz https://api.github.com/repos/microsard81/speed-up/tarball ; tar x -zv -f repo.tar.gz ; rm -f repo.tar.gz ; cd microsard81-speed-up*

#cp -R luci-static/argon /www/luci-static/.

#cp -R themes/argon /usr/lib/lua/luci/view/themes/.

#rm -fR luci-static ; rm -fR themes
