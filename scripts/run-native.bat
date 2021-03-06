@ECHO OFF

IF "%1"=="" (
  ECHO Error. Project directory not specified.
  ECHO.
  ECHO Usage: run-native path\to\directory
  GOTO :NOOP
)

IF NOT EXIST %1 (
  ECHO Project directory not found.
  ECHO USAGE: run-native path/to/project
  GOTO END
)

PUSHD %1

IF NOT EXIST build\native\main.exe (
  ECHO main.exe not found. run build.bat
  GOTO NOOP
)

ECHO Running native...
TASKKILL /IM build\native\main.exe 2> nul
build\native\main.exe

:NOOP
POPD