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
SET pythonCommand=python -m SimpleHTTPServer

py -3 --version 0> NUL 1> NUL 2> NUL
IF NOT ERRORLEVEL 1 (
  SET pythonCommand=py -m http.server 8000
)

START "" http://localhost:8000/
%pythonCommand%

:NOOP
POPD