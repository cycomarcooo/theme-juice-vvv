#!/bin/bash

# Webgrind install (for viewing callgrind/cachegrind files produced by
# xdebug profiler)
if [[ ! -d "/srv/www/default/webgrind" ]]; then
  echo -e "\nDownloading webgrind, see https://github.com/michaelschiller/webgrind.git"
  git clone "https://github.com/michaelschiller/webgrind.git" "/srv/www/default/webgrind"
else
  echo -e "\nUpdating webgrind..."
  cd /srv/www/default/webgrind
  git pull --rebase origin master
fi
