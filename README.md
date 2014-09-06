check_autoit
============

### Requirements

* You don't need to install AutoIT on your windows system if you will run only the *.exe files.
* Configured and running NSClient++ with NRPE on your windows system
* Enable command arguments in the NSC.ini

### Installation

#### Windows
- copy the file check_autoit.bat to your windows system (eg.: %Programmpath%\nsclient++\scripts)
- edit the NSC.ini File and insert follow commandline
- enable script section
- insert follow commandline

check_autoit=scripts\check_autoit.bat $ARG1$ $ARG2$ $ARG3$ $ARG4$ $ARG5$ $ARG6$ $ARG7$ $ARG8$ $ARG9$ $ARG10$


- restart the nsclientpp service on your windows system
- copy the file "wikisearch.exe" and "wikisearch.ini" on your windows system (eg.: c:\test)


#### Icinga

command.cfg

    define command {
      command_name check_autoit
      command_line $USER1$/check_nt -H $HOSTADDRESS$ -p 5666 -c check_autoit -a $ARG1$
    }


services.cfg example

    define service {
      use  ........
      host_name  WINDOWSHOST
      service_description  autoit-wikisearch
      check_command check_autoit!"c:\test\wikilogin.exe c:\test\wikilogin.ini 5 9 nrpe nsclient"
    }



Manual test

    ./check_nt -H IPADDRESS -p 5666 -c check_autoit -a "c:\test\wikilogin.exe c:\test\wikilogin.ini 5 9 nrpe nsclient"



### Declaration


Separate parameters with a single space.

    $ARG1$="Path-wikilogin.exe Path-wikilogin.ini NagiosWarning NagiosCritical Search-String1 Search-String2"


