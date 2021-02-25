@ECHO OFF

IF NOT EXIST build\native\main.exe (
  ECHO main.exe not found. run build.bat
  GOTO NOOP
)

ECHO Running native...
TASKKILL /IM build\native\main.exe 2> nul
build\native\main.exe

:NOOP