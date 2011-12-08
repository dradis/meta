#!/bin/bash
#
# Dradis Framework environment reset script 
#
# License:
#   This file may be used under the terms of the GNU General Public
# License version 2.0 as published by the Free Software Foundation
# and appearing in the file LICENSE.txt included in the packaging of
# this file.
#

export RAILS_ENV=production
cd server

bundle check

if [ $? -eq 1 ] 
then

  echo -n "Some Ruby gems are missing, do you want to install them now? [y] "
  read INSTALL

  if [ "x$INSTALL" = "xy" ]
  then
    echo
    echo -e "Ok then, I am going to run \033[1mbundle install\033[0m for you, then you should run this script again."
    echo

    bundle install
  else
    echo
    echo -e 'You can install the gems manually by going to the ./server/ folder and running: \033[1mbundle install\033[0m'
    echo
  fi

else
  bundle exec thor dradis:reset
fi
