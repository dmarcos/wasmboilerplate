@ECHO OFF

REM Current directory.
FOR /f "delims=" %%A in ('echo %CD%') do SET templateDir=%%A

IF NOT EXIST .\downloads mkdir .\downloads
PUSHD downloads
SET downloadURL=https://download.visualstudio.microsoft.com/download/pr/11503713/e64d79b40219aea618ce2fe10ebd5f0d/vs_BuildTools.exe

REM Drive letter to directory mapping.
FOR /f "delims=" %%A in ('subst') do SET subst="%%A"

REM Deal with driver letter to folder mappings set with subst if any.
if [%subst%]==[] GOTO downloadCompiler

REM Extract drive letter from subst.
SET drive=%subst:~1,3%

REM Extract drive expansion from subst. X:\ => C:\Directory\Path
FOR /f "tokens=2 delims=>" %%a in (%subst%) do (SET drivePath=%%a)
echo %drivePath%

REM Trim leading spaces
call :TRIM drivePath %drivePath%
REM append backlash
set drivePath=%drivePath%\
echo %drivePath%

REM Replace Drive letter with drive expansion for current directory.
REM Taken from https://stackoverflow.com/questions/2772456/string-replacement-in-batch-file/2772498
CALL SET templateDir=%%templateDir:%drive%=%drivePath%%%
echo %drivePath%

:downloadCompiler

SET downloadDestination=%templateDir%\downloads
SET compilerDownloadDestination="%downloadDestination%\vs_BuildTools.exe"
echo %compilerDownloadDestination%

REM Download compiler from Microsoft.
bitsadmin /transfer "Downloading Compiler" /download /priority normal %downloadURL% %compilerDownloadDestination%

popd

IF NOT EXIST .\tools mkdir .\tools
PUSHD tools

SET compilerInstallDestination="%templateDir%\tools"
echo %compilerInstallDestination%

REM https://stackoverflow.com/questions/62551793/how-to-automate-from-command-line-the-installation-of-a-visual-studio-build-to
%compilerDownloadDestination% --wait --norestart --nocache --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.VC.140 --installPath %compilerInstallDestination%

popd

:TRIM
SETLOCAL EnableDelayedExpansion
SET Params=%*
FOR /f "tokens=1*" %%a in ("!Params!") do ENDLOCAL & SET %1=%%b
EXIT /b
