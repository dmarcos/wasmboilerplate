@ECHO OFF

IF "%1"=="" (
  ECHO Error. Project directory not specified.
  ECHO.
  ECHO Usage: run-web path\to\directory
  GOTO :NOOP
)

IF NOT EXIST %1 (
  ECHO Project directory not found.
  ECHO USAGE: run-web path/to/project
  GOTO END
)

CALL scripts/get-current-directory.bat
SET currentDir=%returnValue%


IF NOT EXIST "%1\build\web" (
  ECHO Web version not built. run build.bat
  GOTO NOOP
)

ECHO Running Web...
PUSHD "%1\build\web"

REM Python 2
CALL python -m http.server 8000 2>NUL
IF ERRORLEVEL 1 (
  REM Python 3
  CALL python -m SimpleHTTPServer
)

:NOOP
POPD