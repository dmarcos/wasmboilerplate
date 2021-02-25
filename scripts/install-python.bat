@ECHO OFF

python /? 0> NUL 1 > NUL 2> NUL
IF NOT %ERRORLEVEL%==9009 (
  ECHO Python is already installed in your system. You are all set.
  GOTO NOOP
)

IF NOT EXIST .\downloads mkdir .\downloads

CALL scripts/get-current-directory.bat
SET currentDir=%returnValue%

SET downloadURL=https://www.python.org/ftp/python/3.9.2/python-3.9.2.exe
SET downloadDestination=%currentDir%\downloads
SET compilerDownloadDestination="%downloadDestination%\python-3.9.2.exe"

ECHO Downloading Python...

REM Download compiler from Microsoft.
CALL bitsadmin /transfer "Downloading Python" /download /priority normal %downloadURL% %compilerDownloadDestination%

ECHO Installing Python...
ECHO You might have to click Yes in the installation prompt.

IF NOT EXIST .\tools\python mkdir .\tools\python

SET pythonDir="%currentDir%\tools\python"
CALL downloads\python-3.9.2.exe /quiet TargetDir=%pythonDir%

SET PATH=%pythonDir%;%PATH%

POPD

:NOOP