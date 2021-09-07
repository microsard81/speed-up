#!/bin/sh
#

cp -R luci-static/argon /www/luci-static/.

cp -R themes/argon /usr/lib/lua/luci/view/themes/.

rm -fR luci-static ; rm -fR themes
