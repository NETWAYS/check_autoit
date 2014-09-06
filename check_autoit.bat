@echo off
REM AutoIt-Wrapper for Nagios / NSClient++


REM read commandline with $ARG*$ and set the variable

set Parameter1=%1%
set Parameter2=%2%
set NagWarning=%3%
set NagCritical=%4%
set Parameter5=%5%
set Parameter6=%6%
set Parameter7=%7%


REM start Program with Parameters
start /wait %Parameter1% %Parameter2% %Parameter5% %Parameter6% %Parameter7% 
GOTO :PluginReturn


REM read Pluginreturn
:PluginReturn

set Returncode=%ERRORLEVEL%


REM check Pluginreturn for Nagios
if %Returncode% == 0 Goto :Unknown
if %Returncode% LEQ %NagWarning% GOTO :OK
if %Returncode% LEQ %NagCritical% GoTO :Warning
if %Returncode% GTR %NagCritical% GoTO :Critical


:OK
echo "OK! AutoIt-Script was running in %Returncode% sec. |Time=%Returncode%;%NagWarning%;%NagCritical%"
exit 0

:Warning
echo "Warning! AutoIt-Script was running in %Returncode% sec. |Time=%Returncode%;%NagWarning%;%NagCritical%"
exit 1

:Critical
echo "Critical! AutoIt-Script was running in %Returncode% sec. |Time=%Returncode%;%NagWarning%;%NagCritical%"
exit 2

:Unknown
echo Unknown! Returncode was %Returncode%
exit 3


