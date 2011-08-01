#!/bin/bash
#
# Dradis Framework server start-up script 
#
# License:
#   This file may be used under the terms of the GNU General Public
# License version 2.0 as published by the Free Software Foundation
# and appearing in the file LICENSE.txt included in the packaging of
# this file.
#

# sorry folks, nothing smart going on here
export RAILS_ENV=production
cd server
bundle exec rails server webrick $*
