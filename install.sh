#!/usr/bin/env bash

##  - http://kvz.io/blog/2013/11/21/bash-best-practices/
#set -o errexit  # make script exit when a command fails.
#set -o nounset  # exit when script tries to use undeclared variables.
#set -o xtrace   # trace what gets executed.

ARGS=()
COLLECTD_CONF=""
NVIDIA2GRAPHITE_CONF=""
while [[ "$#" -gt 0 ]]; do
	case "$1" in
		# -h|--help)
		# 	usage
		# 	exit
		# 	;;
		-c|--collectd-conf)
			COLLECTD_CONF="$2"
			shift 2
			;;
		-n|--nvidia2graphite-conf)
			NVIDIA2GRAPHITE_CONF="$2"
			shift 2
			;;
		*)
			ARGS+=("$1")
			shift
			;;
	esac
done


if dpkg-query -l collectd &> /dev/null; then
  echo "Installing collectd..."
  sudo apt-get install collectd
else
  echo "collectd already installed."
fi

if [[ -n "$COLLECTD_CONF" ]]; then
  echo "Copying collectd configuration file '$COLLECTD_CONF' to '/etc/collectd/collectd.conf'..."
  sudo cp /etc/collectd/collectd.conf /etc/collectd/collectd.conf.original
  sudo cp "$COLLECTD_CONF" /etc/collectd/collectd.conf
  sudo systemctl restart collectd.service
fi

if [[ -f /etc/nvidia2graphite.conf ]]; then
  echo "nvidia2graphite already installed."
else
  echo "Downloading nvidia2graphite..."
  wget https://github.com/stefan-k/nvidia2graphite/archive/19263cc0ca5fad223dc7460da678ab38c7f7f257.zip -O /tmp/nvidia2graphite.zip
  unzip /tmp/nvidia2graphite.zip -d /tmp
  if [[ -n "$NVIDIA2GRAPHITE_CONF" ]]; then
    echo "Copying nvidia2graphite configuration file '$NVIDIA2GRAPHITE_CONF'..."
    cp "$NVIDIA2GRAPHITE_CONF" /tmp/nvidia2graphite-19263cc0ca5fad223dc7460da678ab38c7f7f257/nvidia2graphite.conf
  else
    echo "No nvidia2graphite configuration file specified."
  fi
  echo "Installing nvidia2graphite..."
  sudo python3 -m pip install graphitesend==0.10.0
  sudo python3 /tmp/nvidia2graphite-19263cc0ca5fad223dc7460da678ab38c7f7f257/setup.py install
  sudo systemctl enable nvidia2graphite.service
fi

echo "All done."
