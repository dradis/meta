Dradis version 2.6 installation
---------------------------------

General Information
-------------------

Dradis is an open source tool for sharing information.

The official home of the Dradis Framework is:
    http://dradisframework.org/

Please query the website for information and documentation on the system. There 
is also a forum and a #dradis IRC channel at irc.freenode.org.

    http://dradisframework.org/community/

Relese notes can be found in the RELEASE_NOTES document

1. Installation Notes (*nix)
---------------------------
Make sure you have all the dependencies:
$ ./verify.sh
$ bundle install

Reset the environment:
$ rake dradis:reset

That's it, run the server:
$ ruby script\rails server


2. Installation Notes (Windows)
-------------------------------
The dradis installation gives the users the option to install the following
components:
 - Ruby 1.9
 - Dradis Framework Core
 - The SQLite3 library and sqlite3-ruby gem 
 - RedCloth gem
 - Bundler

Note when installing as a limited access user:
The sqlite3 gem are dependant on the following dlls to be in the Windows\system32 
directory or the Ruby\bin directory: 
 - sqlite3.dll
 - msvcr71.dll
 - msvcp71.dll
 - msvcrt.dll

If installer did not have access to the system32 then these files need to be copied 
manually. Simply copy them from the Dradis install directory to the %WINDIR%\system32 
folder or the c:\Ruby192\bin directory.

2.1. Ruby
---------
The ruby installation downloads the Ruby one-click installer and executes it. 
The ruby installation is independent of the Dradis installation.
For best results make sure you tick the *Add Ruby executables to your PATH* checkbox.

2.2. SQLite3
------------
The installer copies the sqlite3.dll file to the $WINDOWS\system32 folder. 
It also copies the sqlite3-ruby gem (version 1.3.2) binary file to the 
installation folder and it then installs the gem locally. 


2.3. RedCloth
-------------
The RedCloth gem is installed locally from the RedCloth-4.2.4pre3-x86-mingw32.gem 
file. RedCloth is used to render the mark-up styled notes to HTML in the browser.


2.4. Dradis Framework Core
--------------------------
All the dradis sever files are copied to the installation folder. 
If the Initialise Dradis checkbox is ticked, the environment is configured and 
the SQLite3 database is re-created.
The rest of the server configuration is left as is. 
The installer creates a short cut to start the server in the Start Menu. 


2.5. Uninstall
--------------
The uninstaller removes the Dradis components from the local system. 

Because other applications might be dependent on the Ruby gems or the Sqlite3.dll 
it is left to the user to remove these manually. 

This can be done with by following these steps:
- run "gem uninstall sqlite3-ruby" in the command line
- run "gem uninstall RedCloth" in the command line
- run "gem uninstall Bundler" in the command line

30th of November 2010
