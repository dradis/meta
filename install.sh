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

TARGET_DIR=$HOME/dradis-git
TARGET_RUBY=1.9.3
CHECK_PASSED=1
PACKAGE_LIST=()

# ========================================= Dependencies: libraries and binaries

# RVM requirements. See:
#   https://github.com/wayneeseguin/rvm/blob/master/scripts/requirements

dradis_apt_binary="$(builtin command -v apt-get)"

if [[ ! -z "$dradis_apt_binary" ]]
then

  for package in build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev autoconf libc6-dev libncurses5-dev automake libtool; do
    echo -n "Searching for: $package... "
    VERSION=$(dpkg-query -W -f='${Status}' $package 2>/dev/null)
    if [[ $? -eq 0 && $VERSION = "install ok installed" ]]; then
      echo -e " [ \e[32;40mfound\e[0m ]."
    else
      CHECK_PASSED=0
      PACKAGE_LIST=("${PACKAGE_LIST[@]} $package")
      echo -e "\e[31;40mNOT found\e[0m."
    fi
  done
fi

# Do we have all the binaries and libraries?
if [[ $CHECK_PASSED -eq 0 ]]; then
  echo "Some required packages were missing, please try installing them with:"
  echo "  apt-get install ${PACKAGE_LIST[@]}"
  exit 1
fi

# ========================================================================= RVM
echo "Installing RVM (Ruby Version Manager) ..."
if [[ -d ~/.rvm ]]; then
  echo "RVM already installed under $HOME/.rvm/"
else

  # Override default behaviour, install under /root/ if run as root. See:
  #   http://beginrescueend.com/support/faq/#root
  if [[ $EUID == 0 ]]; then
    echo "Root user detected. Installing under /root/"
    if [[ -f /root/.rvmrc ]]; then
      echo "Error: no /root/.rvm/ install was found but a /root/.rvmrc file exists."
      echo "Check the contents of this file and rename/delete it before running the installer again."
      exit 1
    else
      echo 'export rvm_prefix="$HOME"' > /root/.rvmrc
      echo 'export rvm_path="$HOME/.rvm"' >> /root/.rvmrc
    fi
  fi

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
#for package in zlib openssl libxslt libxml2; do
#  rvm pkg install $package
#done

# =================================================================== Ruby 1.9.3
echo "Installing Ruby $TARGET_RUBY and making it the default Ruby ..."
rvm get stable
rvm install $TARGET_RUBY
rvm use $TARGET_RUBY --default
gem install bundler --no-rdoc --no-ri

# ================================================================== Dradis repo
echo "Downloading dradis-repo to ~/dradis-git (you can move this folder around later)"
if [[ ! -d $TARGET_DIR ]]; then
  mkdir $TARGET_DIR
  cd $TARGET_DIR
  git clone https://github.com/dradis/dradisframework.git server
else
  echo "Warning, the target directory [$TARGET_DIR] already existed. Reusing it..."
  cd $TARGET_DIR/server/
  git pull origin master
  cd ../
fi
for file in verify reset start; do
  if [[ ! -f $file.sh ]]; then
    curl -O https://raw.github.com/dradis/meta/master/$file.sh
    chmod +x $file.sh
  else
    echo "File [$file.sh] already exists. Skipping."
  fi
done

echo "Please go to ~/dradis-git and run the ./reset.sh script"
echo "Enjoy!"
