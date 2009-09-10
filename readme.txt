Dradis version 2.4 installation
-------------------------------

General Information
-------------------

dradis is an open source tool for sharing information.

The official home of dradis is:
    http://dradisframework.org/

Please query the website for information and documentation on the system. There 
is also a forum and a #dradis IRC channel at irc.freenode.org.

    http://dradisframework.org/community/


The dradis installation gives the users the option to install the following
components:
 - Ruby
 - wxruby gem (the installation of the gem is dependant on a ruby installation)
 - sqlite3 files and sqlite3-ruby gem 
 - dradis server
 - dradis client

Note when installing as a limited access user:
The sqlite3 and wxruby gems are dependant on the following dlls to be in the 
Windows system32 directory: 
 - sqlite3.dll
 - msvcr71.dll
 - msvcp71.dll
 - msvcrt.dll

If installer did not have access to the system32 then these files need to be copied 
manually. Simply copy them from the dradis install directory to the $windows\system32 
folder.

Ruby
----
The ruby installation downloads the ruby one click installer and executes it. 
The ruby installation is independent of the dradis installation.


wxruby 
------
The installer comes with the wxruby gem (version 1.9.9) binary file. 
This file is copied to the installation folder and then the gem is installed locally. 


sqlite3
-------
The installer copies the sqlite3.dll file to the $WINDOWS\system32 folder. 
It also copies the sqlite3-ruby gem (version 1.2.3) binary file to the installation folder 
and it then installs the gem locally. 


dradis server
-------------
All the dardis sever files are copied to the installation folder. 
The sqlite database is created by calling the rake function. 
The rest of the server configuration is left as is. 
The installer creates a short cut to start the server in the Start Menu. 


dradis client
-------------
All the dradis client files are copied to the installation folder. 
The client configuration is left as is. 
The installer creates short cuts to start the dradis command line client and the 
graphical interface client in the Start Menu. 


dradis Meta-Server
------------------
This is the newest component of the framework. It has been developed using 
Rails 2.3.3. This version of rails would require you to upgrade your rubygems
installation. After installing dradis, open a command prompt and type:
  gem update --system

After updating rubygems, there should be no problem in running the meta server
with the standard ./script/server method.

Note that the Meta-Server is provided as a separate package at 
http://dradisframework.org

Uninstall
---------
The uninstaller removes the dradis client and the dradis server from the 
local system. Because other applications might be dependent on the gems or 
the Sqlite3.dll it is left to the user to remove these manually. This can be done with by following these steps:
- run "gem uninstall sqlite3-ruby" in the command line
- run "gem uninstall wxruby" in the command line

