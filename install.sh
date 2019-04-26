#!/usr/bin/env bash

##  - http://kvz.io/blog/2013/11/21/bash-best-practices/
#set -o errexit  # make script exit when a command fails.
#set -o nounset  # exit when script tries to use undeclared variables.
# set -o xtrace   # trace what gets executed.

usage() {
  echo " Usage: $0 [-c COLLECTD_CONF] [-n NVIDIA2GRAPHITE_CONF] [-i] [-s]"
  echo
  echo ' Description:'
  echo "   Install monitoring tools."
  # echo
  # echo ' Arguments:'
  # echo '   ARG - ARG description.'
  echo
  echo ' Options:'
  echo '   -c --collectd-conf COLLECTD_CONF'
  echo "      Replace collectd's configuration file with the one specified."
  echo '   -n --nvidia2graphite-conf NVIDIA2GRAPHITE_CONF'
  echo "      Replace nvidia2graphite's configuration file with the specified one."
  echo '   -i --install-n2g'
  echo '      Reinstall nvidia2graphite if it is already installed.'
  echo '   -s --systemd'
  echo '      Use systemd to enable and restart services.'
  echo '   -h --help'
  echo '      Shows this help message.'
  exit
}

ARGS=()
COLLECTD_CONF=""
NVIDIA2GRAPHITE_CONF=""
INSTALL_N2G=""
USE_SYSTEMD=""
while [[ "$#" -gt 0 ]]; do
	case "$1" in
		-h|--help)
			usage
			exit
			;;
		-c|--collectd-conf)
			COLLECTD_CONF="$2"
			shift 2
			;;
		-n|--nvidia2graphite-conf)
			NVIDIA2GRAPHITE_CONF="$2"
			shift 2
			;;
    -i|--install-n2g)
      INSTALL_N2G="true"
      shift
      ;;
		-s|--systemd)
      USE_SYSTEMD="true"
      shift
      ;;
    *)
			ARGS+=("$1")
			shift
			;;
	esac
done

# When mounted with sshfs, it is not possible to copy files with sudo. This is a workaround.
gamp_cp() {
  cp "$1" /tmp/temp.cp
  sudo cp /tmp/temp.cp "$2"
}

################
### COLLECTD ###
################

if ! dpkg-query -l collectd &> /dev/null; then
  echo "Installing collectd..."
  sudo apt-get install collectd
else
  echo "collectd already installed."
fi

if [[ -n "$COLLECTD_CONF" ]]; then
  echo "Copying collectd configuration file '$COLLECTD_CONF' to '/etc/collectd/collectd.conf'..."
  sudo cp /etc/collectd/collectd.conf /etc/collectd/collectd.conf.original
  gamp_cp "$COLLECTD_CONF" "/etc/collectd/collectd.conf"
  if [[ -n "$USE_SYSTEMD" ]]; then
    sudo systemctl restart collectd.service
  fi
fi

#######################
### NVIDIA2GRAPHITE ###
#######################

# FIXME: nvidia2graphite currently only installs to systemd.

if [[ -n "$INSTALL_N2G" || ! -f /etc/nvidia2graphite.conf ]]; then
  echo "Downloading nvidia2graphite..."
  wget https://github.com/possatti/nvidia2graphite/archive/8b13ebdbab15176a3b83c9d18d5127474b6f4cd3.zip -O /tmp/nvidia2graphite.zip
  unzip -o /tmp/nvidia2graphite.zip -d /tmp
  echo "Installing nvidia2graphite..."
  sudo python3 -m pip install graphitesend==0.10.0
  sudo python3 /tmp/nvidia2graphite-8b13ebdbab15176a3b83c9d18d5127474b6f4cd3/setup.py install
  if [[ -n "$USE_SYSTEMD" ]]; then
    sudo systemctl enable nvidia2graphite.service
  fi
else
  echo "nvidia2graphite already installed."
fi

if [[ -n "$NVIDIA2GRAPHITE_CONF" ]]; then
  echo "Copying nvidia2graphite configuration file '$NVIDIA2GRAPHITE_CONF' to '/etc/nvidia2graphite.conf'..."
  gamp_cp "$NVIDIA2GRAPHITE_CONF" "/etc/nvidia2graphite.conf"
  if [[ -n "$USE_SYSTEMD" ]]; then
    sudo systemctl restart nvidia2graphite.service
  fi
else
  echo "No nvidia2graphite configuration file specified."
fi

echo "All done."
