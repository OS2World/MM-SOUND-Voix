@echo off

rem //temp file settings
set tempin=tmpin00.wav
set tempout=tmpout00.wav

rem //copyright information 

echo VoiX mp3 ver 1.0.0 beta 5 (batch command)
echo (http://vocaleliminator.sourceforge.net)
echo.

if not exist voix.exe set filenotfound=voix.exe
if not exist voix.exe goto :fileerror
if not exist lame.exe set filenotfound=lame.exe
if not exist lame.exe goto :fileerror

if "%1"=="--help" goto voixhelp
if "%1"=="/?" goto voixhelp
if "%1"=="-?" goto voixhelp
if "%1"=="" goto usage
if "%2"=="" goto noout
set lowpass=%3
set highpass=%4
if "%3"=="" set lowpass=200
if "%4"=="" set highpass=8000
set mp3encopt=
if not "%5"=="" set mp3encopt=%5
if not "%6"=="" set mp3encopt=%mp3encopt% %6
if not "%7"=="" set mp3encopt=%mp3encopt% %7
if not "%8"=="" set mp3encopt=%mp3encopt% %8
if not "%9"=="" set mp3encopt=%mp3encopt% %9
set filenotfound=
goto :lamedecode

:noout
echo Error: no output file!
echo.
goto usage

:voixhelp
echo Usage: voixmp3 (in) (out) [lowpass] [highpass] [lame options]
echo.
echo RECOMMENDED:
echo     voixmp3 input.mp3 output.mp3 200 8000 -V2
echo.
echo OPTIONS:
echo     in              the original song in mp3 format. example: input.mp3
echo.
echo     out             the devocalized background music in mp3 format. example:
echo                     output.mp3
echo.
echo     lowpass         the cutoff frenquency (Hz) of low-pass filter for voix.
echo.
echo     highpass        the cutoff frenquency (Hz) of high-pass filter for voix.
echo.
echo     lame options    mp3 encoding options for LAME.
echo.
goto end

:usage
echo Usage: voixmp3 (in) (out) [lowpass] [highpass] [lame options]
echo.
echo Type "%0 --help" for details.
echo.
goto end

:lamedecode
if not exist %1 set filenotfound=%1
if not exist %1 goto :fileerror
cls
echo VoiX mp3 ver 1.0.0 beta 5 (batch command)
echo (http://vocaleliminator.sourceforge.net)
echo.
echo Decoding using LAME...
echo                ~~~~
echo ===============================================================================
lame.exe --decode %1 "%tmp%\%tempin%"
echo ===============================================================================
echo.
if not exist %tmp%\%tempin% set filenotfound=%tmp%\%tempin%
if not exist %tmp%\%tempin% goto :fileerror
goto voixprocess

:voixprocess
cls
echo VoiX mp3 ver 1.0.0 beta 5 (batch command)
echo (http://vocaleliminator.sourceforge.net)
echo.
echo Devocalizing using VoiX...
echo                    ~~~~
echo ===============================================================================
voix.exe "%tmp%\%tempin%" "%tmp%\%tempout%" %lowpass% %highpass%
echo ===============================================================================
echo.
echo Deleting "%tmp%\%tempin%"...
del %tmp%\%tempin%
echo.
if not exist %tmp%\%tempout% set filenotfound=%tmp%\%tempout%
if not exist %tmp%\%tempout% goto :fileerror
goto lameencode

:lameencode
cls
echo VoiX mp3 ver 1.0.0 beta 5 (batch command)
echo (http://vocaleliminator.sourceforge.net)
echo.
echo Encoding using LAME...
echo                ~~~~
echo ===============================================================================
if "%mp3encopt%"=="" lame.exe "%tmp%\%tempout%" %2
if not "%mp3encopt%"=="" lame.exe %mp3encopt% "%tmp%\%tempout%" %2
echo ===============================================================================
echo.
echo Deleting "%tmp%\%tempout%"...
del %tmp%\%tempout%
echo.
if not exist %2 set filenotfound=%2
if not exist %2 goto :fileerror
goto success

:success
echo success: dong processing file!
echo.
goto end

:fileerror
echo error: file %filenotfound% could not be found.
echo.
goto :end

:end
