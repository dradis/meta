#!/usr/bin/env bash
#
# Dradis Framework installation script
#
# Description:
#   This script will install all the necessary dependencies required to run the
# Dradis Framework.
#
# If any of them should be run as root, the script will provide the instructions
# to do so.
#
# License:
#   This file may be used under the terms of the GNU General Public
# License version 2.0 as published by the Free Software Foundation
# and appearing in the file LICENSE.txt included in the packaging of
# this file.
#
# Copyright: Security Roots Ltd. 

TARGET_RUBY=1.9.3
CHECK_PASSED=1

# ======================================================= Dependencies: libraries
echo -n "Looking for the libxml2 libraries and headers... "
which xml2-config > /dev/null
if [ $? -eq 0 ]; then
  echo "found."
else
  CHECK_PASSED=0
  echo -e "\e[31;40mNOT found\e[0m. Try installing with:"
  echo "  apt-get install libxml2-dev libxslt1-dev"
fi


# ======================================================= Dependencies: binaries
echo -n "Checking for system dependencies: git..."
which git > /dev/null
if [[ $? -eq 0 ]]; then
  GIT_EXEC=`which git`
  echo -e "found [ \e[32;40m$GIT_EXEC\e[0m ]."
else
  CHECK_PASSED=0
  echo -e "\e[31;40mNOT found\e[0m. Try installing with:"
  echo "  apt-get install git"
fi

echo -n "Checking for system dependencies: curl... "
which curl > /dev/null
if [[ $? -eq 0 ]]; then
  CURL_EXEC=`which curl`
  echo -e "found [ \e[32;40m $CURL_EXEC\e[0m ]."
else
  CHECK_PASSED=0
  echo -e "\e[31;40mNOT found\e[0m. Try installing with:"
  echo "  apt-get install curl"
fi

echo -n "Checking for system dependencies: autoconf... "
which autoconf > /dev/null
if [[ $? -eq 0 ]]; then
  AUTOCONF_EXEC=`which autoconf`
  echo -e "found [ \e[32;40m $AUTOCONF_EXEC\e[0m ]."
else
  CHECK_PASSED=0
  echo -e "\e[31;40mNOT found\e[0m. Try installing with:"
  echo "  apt-get install autoconf"
fi

# Do we have all the binaries and libraries?
if [[ $CHECK_PASSED -eq 0 ]]; then
  exit 1
fi

# ========================================================================= RVM
echo "Installing RVM (Ruby Version Manager) ..."
if [[ -d ~/.rvm ]]; then
  echo "RVM already installed under $HOME/.rvm/"
else
  bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
fi

# Load RVM if available
if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
  . "$HOME/.rvm/scripts/rvm"
  echo "RVM version: `rvm version | awk '{print $2}'`"
else
  echo "There is something wrong with the RVM installation $HOME/.rvm/scripts/rvm not found. Consider reinstalling."
fi

# Load additional RVM packages
for package in zlib openssl libxslt libxml2; do
  rvm pkg install $package
done

# =================================================================== Ruby 1.9.3
echo "Installing Ruby $TARGET_RUBY and making it the default Ruby ..."
rvm get head
rvm install $TARGET_RUBY
rvm use $TARGET_RUBY --default

# ================================================================== Dradis repo
echo "Downloading dradis-repo to ~/dradis-git (you can move this folder around later)"
mkdir $HOME/dradis-git
cd $HOME/dradis-git
git clone https://github.com/dradis/dradisframework.git server
for file in verify reset start; do
  curl -O https://raw.github.com/dradis/meta/master/$file.sh
done
chmod +x *.sh

