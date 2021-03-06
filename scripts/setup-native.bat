@ECHO OFF

cl /? 0> NUL 1 > NUL 2> NUL
IF NOT %ERRORLEVEL%==9009 (
  ECHO Visual studio build tools found in your system. You are all set.
  GOTO NOOP
)

IF EXIST ".\tools\vs\VC\Tools\MSVC\14.16.27023\bin\Hostx86\x86\cl.exe" (
  ECHO Visual studio build tools already installed locally in the tools\vs directory. You are all set
  GOTO NOOP
)

CALL scripts/get-current-directory.bat
SET currentDir=%returnValue%

SET downloadURL=https://download.visualstudio.microsoft.com/download/pr/11503713/e64d79b40219aea618ce2fe10ebd5f0d/vs_BuildTools.exe
SET downloadDestination=%currentDir%\downloads
SET compilerDownloadDestination="%downloadDestination%\vs_BuildTools.exe"

IF EXIST %compilerDownloadDestination% (
  ECHO Visual studio build tools already downloaded.
  GOTO INSTALL
)

IF NOT EXIST .\downloads mkdir .\downloads

ECHO Downloading Visual Studio Build Tools...

REM Download compiler from Microsoft.
CALL bitsadmin /transfer "Downloading Visual Studio Build Tools" /download /priority foreground %downloadURL% %compilerDownloadDestination%

:INSTALL

IF NOT EXIST .\tools\vs mkdir .\tools\vs

SET compilerInstallDestination="%currentDir%\tools\vs"

ECHO Installing Visual Studio Build Tools...
ECHO ~4GB download, It might take a bit depending on your connection. Thanks for the patience.
ECHO You might have to click Yes in the installation prompt.

REM https://stackoverflow.com/questions/62551793/how-to-automate-from-command-line-the-installation-of-a-visual-studio-build-to
CALL %compilerDownloadDestination% --quiet --wait --norestart --nocache --add Microsoft.VisualStudio.Workload.VCTools --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.VC.140 --add Microsoft.VisualStudio.Component.Windows10SDK.17763 --installPath %compilerInstallDestination%

:NOOP
