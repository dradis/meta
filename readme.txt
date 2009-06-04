Dradis version 2.2 installation
-------------------------------

General Information
-------------------

dradis is an open source tool for sharing information.

The official home of dradis is:
    http://dradis.sourceforge.net/

Please query the website for information and documentation on the system.


The dradis installation gives the users the option to install the following components:
- Ruby
- wxruby gem (the installation of the gem is dependant on a ruby installation)
- sqlite3 files and sqlite3-ruby gem 
- dradis server
- dradis client

Note when installing as a limited access user:
The sqlite3 and wxruby gems are dependant on the following dlls to be in the system32: 
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


Uninstall
---------
The uninstaller removes the dradis client and the dradis server from the 
local system. Because other applications might be dependent on the gems or 
the Sqlite3.dll it is left to the user to remove these manually. This can be done with by following these steps:
- run "gem uninstall sqlite3-ruby" in the command line
- run "gem uninstall wxruby" in the command line


3 May 2009
