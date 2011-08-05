#!/bin/bash
#
# Dradis Framework dependencies verification script
#
# Description:
#   This script will try to determine whether all the dependencies required to
# use the Dradis Framework are present in the system providing hints on how to 
# install the missing dependencies. The system will NOT be modified by the 
# script.
# 
# License:
#   This file may be used under the terms of the GNU General Public
# License version 2.0 as published by the Free Software Foundation
# and appearing in the file LICENSE.txt included in the packaging of
# this file.
#
# Copyright: Daniel Martin Gomez <etd[-at-]nomejortu.com>

echo
echo "Dradis Framework dependencies verification script"
echo "-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --"
echo 
echo "  This script will try to determine whether all the dependencies required to"
echo "use the Dradis Framework are present in the system providing hints on how to"
echo "install the missing dependencies. The system will NOT be modified by the"
echo "script."
echo
echo -e "Please send your feedback about this script to:\n\tfeedback [you-know-what] dradisframework.org"
echo 
echo 

EXTENDED=0
#echo "There are a number of verifications you can perform:"
#echo "  1) Standard: Ruby interpreter and database drivers (recommended)"
#echo "  2) Extended: Ruby interpreter, database drivers and GUI libraries"
#
#echo -e "What set of checks do you want to run? [1] \c"
#read CHOICE
#
#case $CHOICE in
#  2) EXTENDED=1
#esac
#
#echo
if [ $EXTENDED -eq 1 ]; then
  echo "Running Extended checks."
else
  echo "Running Standard checks."
fi;
echo

# verify ruby
echo -n "Looking for Ruby interpreter... "
which ruby > /dev/null
if [ $? -eq 0 ]; then
  RUBY_EXEC=`which ruby`
  echo -e 'found [\E[32;40m' $RUBY_EXEC '\E[0m].'
else
  echo -e '\E[31;40mNOT found\E[0m'
  echo
  echo "Ruby interpreter not found. Try:"
  echo "  apt-get install ruby irb rdoc ruby-dev libopenssl-ruby"
  echo 
  exit 1
fi;

# verify ruby-dev (mkmf) for native extension support
echo -n "Checking for support to compile native extensions... " 

ruby -rmkmf -e nil 2> /dev/null
if [ $? -eq 0 ]; then
  echo "found."
else
  echo -e '\E[31;40mNOT found\E[0m'
  echo
  echo "Ruby development libraries not found. Try:"
  echo "  apt-get install ruby-dev libopenssl-ruby"
  echo 
  exit 2
fi;

# verify gems
echo -n "Looking for RubyGems and the 'gem' command... "
which gem > /dev/null
if [ $? -eq 0 ]; then
  GEM_EXEC=`which gem`
  echo -e 'found [\E[32;40m' $GEM_EXEC '\E[0m].'
else
  echo -e '\E[31;40mNOT found\E[0m'
  echo
  echo "RubyGems not found. Try:"
  echo "  apt-get install rubygems"
  echo 
  exit 3
fi;


# verify Bundler  gem
echo -n "Looking for the Ruby Bundler gem [bundler]... "
ruby -rrubygems -e "gem 'bundler', '~> 1.0'" 2> /dev/null
if [ $? -eq 0 ]; then
  BUNDLER_VERSION=`ruby -rrubygems -e "require 'bundler/version'; puts Bundler::VERSION"`
  echo -e 'found [ \E[32;40mv'$BUNDLER_VERSION'\E[0m ].'
else
  echo -e '\E[31;40mNOT found\E[0m'
  echo
  echo "Bundler ruby gem (bundler [~> 1.0]) not found. Try: "
  echo "  gem install bundler"
  echo 
  exit 4
fi;


# verify Bundler binary
echo "Looking for the Ruby Bundler binary... "
echo -e -n '  ** locating using the PATH variable... '
which bundle > /dev/null
if [ $? -eq 0 ]; then
  BUNDLER_EXEC=`which bundle`
  BUNDLER_IN_PATH=1
  echo -e 'found [\E[32;40m' $BUNDLER_EXEC '\E[0m].'
else
  BUNDLER_IN_PATH=0
  echo -e '\E[31;40mNOT found\E[0m'
  echo -e -n '  ** locating using RubyGems... '
  GEM_BINDIR=`ruby -rrubygems -e "puts Gem::bindir"`
  if [ -x $GEM_BINDIR'/bundle' ]; then
    BUNDLER_EXEC=$GEM_BINDIR'/bundle'
    echo -e 'found [\E[32;40m' $BUNDLER_EXEC '\E[0m].'
  else
    echo '\E[31;40mNOT found.\E[0m Unable to locate Bundler binary.'
    echo 
    exit 5
  fi;
fi;


# verify SQLite3 libraries
echo -n "Looking for the SQLite3 libraries... "
ruby -rmkmf -e "if (have_header( 'sqlite3.h' ) && have_library( 'sqlite3', 'sqlite3_open' )) then exit 0 else exit 1 end" > /dev/null
if [ $? -eq 0 ]; then
  echo "found."
else
  echo -e '\E[31;40mNOT found\E[0m'
  echo
  echo "SQLite3 libraries not found. Try: "
  echo "  apt-get install libsqlite3-0 libsqlite3-dev"
  echo
  exit 6
fi;

# verify SQLite3 bindings for Ruby
echo -n "Looking for the SQLite3 ruby gem [sqlite3-ruby]... "
ruby -rrubygems -e "gem 'sqlite3-ruby', '>=1.2.4'" 2> /dev/null
if [ $? -eq 0 ]; then
  SQLITERUBY_VERSION=`ruby -rrubygems -e "require 'sqlite3/version'; puts SQLite3::Version::STRING"`
  echo -e 'found [ \E[32;40mv'$SQLITERUBY_VERSION'\E[0m ].'
else
  echo -e '\E[31;40mNOT found\E[0m'
  echo
  echo "SQLite3 ruby gem (sqlite3-ruby [>= 1.2.4]) not found. Try: "
  echo "  gem install sqlite3-ruby"
  echo
  exit 7
fi;

if [ $EXTENDED -eq 1 ]; then 

  # verify wxWidgets libraries
  echo -n "Looking for wxWidgets 2.8 (GTK backend) libraries... "
  # TODO: the full list should be whatever `wx-config --libs` returns, however 
  #       wx-config only comes with libwxgtk2.8-dev which is not required 
  #       because the gem is not compiled. We assume having the main 
  #       'wx_baseu-2.8' component will be good enough
  #wx_gtk2u_core-2.8
  #ruby -rmkmf -e "if (have_library( 'wx_baseu-2.8' )) then exit 0 else exit 1 end" > /dev/null
  ruby -rmkmf -e "if (have_library( 'wx_gtk2u_core-2.8' )) then exit 0 else exit 1 end" > /dev/null
  if [ $? -eq 0 ]; then
    echo "found."
  else
    echo -e '\E[31;40mNOT found\E[0m'
    echo
    echo "wxWidgets 2.8 (GTK) libraries not found. Try: "
    echo "  apt-get install libwxgtk2.8-0 libwxgtk2.8-dev"
    echo
    exit 8
  fi;


  # verify wxWidgets bindings for Ruby
  echo -n "Looking for the wxWidgets ruby gem [wxruby]... "
  ruby -rrubygems -e "gem 'wxruby', '>=1.9.9'" 2> /dev/null
  if [ $? -eq 0 ]; then
    WXRUBY_VERSION=`ruby -rrubygems -e "require 'wx'; puts Wxruby2::WXRUBY_VERSION"`
    echo -e 'found (\E[32;40mv'$WXRUBY_VERSION'\E[0m).'
  else
    echo -e '\E[31;40mNOT found\E[0m'
    echo
    echo "wxWidgets ruby gem (wxruby [>=1.9.9]) not found. Try: "
    echo "  gem install wxruby"
    echo
    exit 9
  fi;

fi;

# verify LibXML2 libraries and headers
echo -n "Looking for the LibXML2 libraries and headers... "
which xml2-config > /dev/null
if [ $? -eq 0 ]; then
  echo "found."
else
  echo -e '\E[31;40mNOT found\E[0m'
  echo
  echo "LibXML2 libraries not found. Try: "
  echo "  apt-get install libxml2-dev libxslt1-dev"
  echo
  exit 10
fi;

# clean up
if [ -e "mkmf.log" ]; then
  rm mkmf.log
fi;

echo
echo "Congratulations. You seem to be ready to run the Dradis Framework."
echo
echo "Remember that you still need to go to the server/ folder and run:"
if [ $BUNDLER_IN_PATH  -eq 1 ]; then
echo -e "\tbundle install"
else
echo -e "\t$BUNDLER_EXEC install"
fi;
echo
echo "Enjoy!"
echo
