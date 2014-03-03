#!/bin/bash
#
# Dradis Framework environment reset script 
#
# Description:
#   This script will install gem dependencies using Bundler, precompile the
# assets for Rails' asset pipeline and reset the Dradis environment (config
# and database)
#
# License:
#   This file may be used under the terms of the GNU General Public
# License version 2.0 as published by the Free Software Foundation
# and appearing in the file LICENSE.txt included in the packaging of
# this file.
#
# Copyright: Security Roots Ltd

# This loads RVM if available which is needed to process the ./server/.rvmrc
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

export RAILS_ENV=production
cd server

# ========================================================= Bundler dependencies
bundle check

if [[ $? -eq 1 ]]; then
  echo -n "Some Ruby gems are missing, do you want to install them now? [y] "
  read INSTALL

  if [[ "x$INSTALL" = "xy" ]]; then
    echo
    echo -e "Ok then, I am going to run \033[1mbundle install\033[0m for you."
    echo

    bundle install
  else
    echo
    echo -e 'You can install the gems manually by going to the ./server/ folder and running: \033[1mbundle install\033[0m'
    echo
    exit 1
  fi
fi

# ========================================================= Rails asset pipeline

if [[ ! -d public/assets/ ]]; then
  echo -n "Looks like you have not precompiled the Rails assets yet, do you want to do it now? [y] "
  read ASSETS

  if [[ "x$ASSETS" = "xy" ]]; then
    echo
    echo -e "Ok then, I am going to run the \033[1massets:precompile\033[0m task for you."
    echo

    bundle exec rake RAILS_ENV=production assets:precompile
  else
    echo
    echo "You can precompile the assets manually by going to the ./server/ folder and running:"
    echo -e "  \033[1mRAILS_ENV=production bundle exec rake assets:precompile\033[0m"
    echo
    exit 1
  fi
fi

# ================================================================= dradis:reset
bundle exec thor dradis:reset
