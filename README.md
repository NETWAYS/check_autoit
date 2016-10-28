check_autoit
============

### Requirements

* You don't need to install AutoIT on your windows system if you will run only the *.exe files.
* Configured and running NSClient++ with NRPE on your windows system or Icinga 2 Agent
* Enable command arguments in the NSC.ini (check_autoit.bat)
* Use check_autoit.ps1 while using the Icinga 2 Agent

### Installation

#### Windows

NSClient++

- copy the file check_autoit.bat to your windows system (eg.: %Programmpath%\nsclient++\scripts)
- edit the NSC.ini File and insert follow commandline
- enable script section
- insert follow commandline

check_autoit=scripts\check_autoit.bat $ARG1$ $ARG2$ $ARG3$ $ARG4$ $ARG5$ $ARG6$ $ARG7$ $ARG8$ $ARG9$ $ARG10$

- restart the nsclientpp service on your windows system
- copy the file "wikisearch.exe" and "wikisearch.ini" on your windows system (eg.: c:\test)

Icinga 2

- copy the file check_autoit.ps1 to any directory Icinga 2 has access too
- continue with Icinga 2 part

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


#### Icinga 2

check_autoit.conf

    object CheckCommand "Check AutoIT" {
        import "plugin-check-command"
        command = [
            "C:\\Windows\\SysWOW64\\WindowsPowerShell\\v1.0\\powershell.exe"
        ]
        arguments = {
            "-Script-File" = {
                order = 0
                skip_key = true
                value = "$powershell_script_file$"
                description = "The script file which should be executed by the PowerShell"
            }
            "-Executable" = {
                order = 1
                value = "$autoit_executable$"
                description = "This is the path to the AutoIT executable"
            }
            "-ConfigFile" = {
                order = 2
                value = "$autoit_config_file$"
                description = "If your AutoIT script comes with a configuration file you can specify it with this parameter"
            }
            "-WarningValue" = {
                order = 3
                value = "$autoit_warning_value$"
                description = "The warning threshold for the script runtime"
            }
            "-CriticalValue" = {
                order = 4
                value = "$autoit_critical_value$"
                description = "The critical threshold for the script runtime"
            }            
            "-Arguments" = {
                order = 5
                value = "$autoit_arguments$"
                description = "Array of possible additional arguments required for the AutoIT script to run properly"
            }
            "; exit" = {
                order = 99
                value = "$$LASTEXITCODE"
                description = "Exit our PowerShell instance with the exit code of the script to report data correctly to Icinga 2"
            }
        }
    }
    
autoit_service_template.conf

    template Service "Check AutoIT by PowerShell" {
        import "generic-service"
        check_command = "Check AutoIT"
        
        vars.powershell_script_file = "& 'C:\\test\\check_autoit.ps1'"
        vars.autoit_executable = "C:\\test\\wikisearch.exe"
        vars.autoit_config_file = "C:\\test\\wikisearch.ini"        
        vars.autoit_warning_value = "5"
        vars.autoit_critical_value = "9"
        vars.autoit_arguments = "'nrpe', 'test'"
    }
    
autoit_service_apply.conf

    apply Service "Check AutoIT by PowerShell" {
        import "Check AutoIT by PowerShell"

        assign where host.vars.autoit == true
    }
    
Manual test

    PS C:\test>.\check_autoit.ps1 -Executable "C:\test\wikisearch.exe" -ConfigFile "C:\test\wikisearch.ini" -WarningValue 5 -CriticalValue 9 -Arguments 'nrpe', 'nsclient'