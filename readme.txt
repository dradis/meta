0. In this document
===============================================================================
  1. General Information
  2. Installation Notes (*nix)
  3. Installation Notes (Windows)
  4. Running Dradis

Dradis 2.6 - 2nd of December 2010


1. General Information
===============================================================================

Dradis is an open source tool for sharing information.

The official home of the Dradis Framework is:
    http://dradisframework.org/

Please query the website for information and documentation on the system. There 
is also a forum and a #dradis IRC channel at irc.freenode.org.

    http://dradisframework.org/community/

Relese notes can be found in the RELEASE_NOTES document


1. Installation Notes (*nix)
===============================================================================
Make sure you have all the dependencies:
$ ./verify.sh
$ bundle install

Reset the environment:
$ rake dradis:reset

That's it, run the server:
$ ruby script\rails server


2. Installation Notes (Windows)
===============================================================================
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


3. Running Dradis
===============================================================================

3.1 Reset the environment
-------------------------
The Dradis *reset* script will download and install all the necessary libraries 
for you the first time you run it.

In Windows, there is a reset link in the Start menu group or you can go to the 
installation folder and run:

    reset.bat 

In *NIX simply run:

    reset.sh 

The script will use Bundler to install all the dependencies listed in 
./server/Gemfile and will set up the environment for first use.

3.2 Launch the server
---------------------
In Windows use the start server link or go to the Dradis folder and run:

    start.bat 

In *NIX just run:

    start.sh 

You can verify that everything is running as it should by pointing your browser to:

https://localhost:3004/

For more information regarding Dradis startup visit:
  http://dradisframework.org/configure.html
