@ECHO OFF

IF NOT EXIST .\build\web (
  ECHO WASM not found. run build.bat
  GOTO NOOP
)

ECHO Running Web...
TASKKILL /IM tools\sheret\sheret.exe 2> nul
tools\sheret\sheret.exe -d .\build\web

:NOOP