@ECHO OFF

cl /? 0> NUL 1 > NUL 2> NUL
IF NOT %ERRORLEVEL%==9009 (
  ECHO Visual studio build tools found in your system. You are all set
  GOTO NOOP
)

IF EXIST ".\tools\vs\VC\Tools\MSVC\14.16.27023\bin\Hostx86\x86\cl.exe" (
  ECHO Visual studio build tools already installed locally in the tools\vs directory. You are all set
  GOTO NOOP
)

REM Current directory.
FOR /f "delims=" %%A in ('echo %CD%') do SET templateDir=%%A

IF NOT EXIST .\downloads mkdir .\downloads
PUSHD downloads

REM Drive letter to directory mapping.
FOR /f "delims=" %%A in ('subst') do SET subst="%%A"

REM Deal with driver letter to folder mappings set with subst if any.
IF [%subst%]==[] GOTO downloadCompiler

REM Extract drive letter from subst.
SET drive=%subst:~1,3%

REM Extract drive expansion from subst. X:\ => C:\Directory\Path
FOR /f "tokens=2 delims=>" %%a in (%subst%) do (SET drivePath=%%a)

REM Trim leading spaces
CALL :TRIM drivePath %drivePath%
REM append backlash
SET drivePath=%drivePath%\

REM Replace Drive letter with drive expansion for current directory.
REM Taken from https://stackoverflow.com/questions/2772456/string-replacement-in-batch-file/2772498
CALL SET templateDir=%%templateDir:%drive%=%drivePath%%%

:downloadCompiler

SET downloadURL=https://download.visualstudio.microsoft.com/download/pr/11503713/e64d79b40219aea618ce2fe10ebd5f0d/vs_BuildTools.exe
SET downloadDestination=%templateDir%\downloads
SET compilerDownloadDestination="%downloadDestination%\vs_BuildTools.exe"

ECHO Downloading Visual Studio Build Tools...

REM Download compiler from Microsoft.
bitsadmin /transfer "Downloading Visual Studio Build Tools" /download /priority normal %downloadURL% %compilerDownloadDestination%

POPD

IF NOT EXIST .\tools mkdir .\tools
PUSHD tools

IF NOT EXIST .\vs mkdir .\vs
PUSHD vs

SET compilerInstallDestination="%templateDir%\tools\vs"

ECHO Installing Visual Studio Build Tools... (~4GB download, It might take a bit depending on your connection. Thanks for the patience)
ECHO You might have to click Yes in the installation prompt.

REM https://stackoverflow.com/questions/62551793/how-to-automate-from-command-line-the-installation-of-a-visual-studio-build-to

CALL %compilerDownloadDestination% --quiet --wait --norestart --nocache --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.VC.140 --add Microsoft.VisualStudio.Component.Windows10SDK.17763 --installPath %compilerInstallDestination%

POPD
POPD

:TRIM
SETLOCAL EnableDelayedExpansion
SET Params=%*
FOR /f "tokens=1*" %%a in ("!Params!") do ENDLOCAL & SET %1=%%b
EXIT /b

:NOOP
