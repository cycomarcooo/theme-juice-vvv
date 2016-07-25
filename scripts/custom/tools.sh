#!/bin/bash

# wp-cli
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# ack-grep
#
# Install ack-rep directory from the version hosted at beyondgrep.com as the
# PPAs for Ubuntu Precise are not available yet.
if [[ -f /usr/bin/ack ]]; then
  echo "ack-grep already installed"
else
  echo "Installing ack-grep as ack"
  curl -s http://beyondgrep.com/ack-2.14-single-file > "/usr/bin/ack" && chmod +x "/usr/bin/ack"
fi

# Graphviz
#
# Set up a symlink between the Graphviz path defined in the default Webgrind
# config and actual path.
echo "Adding graphviz symlink for Webgrind..."
ln -sf "/usr/bin/dot" "/usr/local/bin/dot"
