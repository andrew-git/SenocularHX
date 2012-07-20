::
:: Copyright 2012, Andras Csizmadia <andras@vpmedia.eu>.
::

:: Echo off and begin localisation of Environment Variables
@ECHO OFF & SETLOCAL

:: Prepare the Command Processor
VERIFY errors 2>nul
SETLOCAL ENABLEEXTENSIONS
IF ERRORLEVEL 1 ECHO Warning: Unable to enable extensions.
SETLOCAL ENABLEDELAYEDEXPANSION

:: Save base directory
PUSHD %CD%
::PUSHD %~dp0

:: Set title
TITLE %~n0

:: STARTUP  
haxe -xml doc.xml -swf main.swf -lib nme -cp ../src ImportAll
del main.swf
haxedoc doc.xml -f senocular