#!/bin/bash
# Author: Yevgeniy Goncharov aka xck, http://sys-adm.in
# Reboot required checker.

# Sys env / paths / etc
# -------------------------------------------------------------------------------------------\
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

# Fncs
# ---------------------------------------------------\

# Check is current user is root
isRoot() {
  if [ $(id -u) -ne 0 ]; then
    echo "You must be root user to continue"
    exit 1
  fi
  RID=$(id -u root 2>/dev/null)
  if [ $? -ne 0 ]; then
    echo "User root no found. You should create it to continue"
    exit 1
  fi
  if [ $RID -ne 0 ]; then
    echo "User root UID not equals 0. User root must have UID 0"
    exit 1
  fi
}

# Checks supporting distros
checkDistro() {
    # Checking distro
    if [ -e /etc/centos-release ]; then
        DISTRO=`cat /etc/redhat-release | awk '{print $1,$4}'`
        RPM=1
    elif [ -e /etc/fedora-release ]; then
        DISTRO=`cat /etc/fedora-release | awk '{print ($1,$3~/^[0-9]/?$3:$4)}'`
        RPM=2
    elif [ -e /etc/os-release ]; then
        DISTRO=`lsb_release -d | awk -F"\t" '{print $2}'`
        RPM=0
        DEB=1
    else
        Error "Your distribution is not supported (yet)"
        exit 1
    fi
}

check_Debian() {
    if [ -f /var/run/reboot-required ]; then
        echo 'Reboot required'
  else
        echo 'Reboot not needed'
    fi
}

# Acts
# ---------------------------------------------------\

isRoot
checkDistro
if [[ "$RPM" -eq "1" ]]; then
    echo "CentOS detected... Not supported at current time. Exit."   
    exit 1
elif [[ "$RPM" -eq "2" ]]; then
    echo "Fedora detected... Not supported at current time. Exit."
    exit 1
elif [[ "$DEB" -eq "1" ]]; then
    echo "Debian detected... "
    check_Debian
else
    echo "Unknown distro. Exit."
    exit 1
fi




