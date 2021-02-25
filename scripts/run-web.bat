@ECHO OFF

IF "%1"=="" (
  ECHO Error. Project directory not specified.
  ECHO.
  ECHO Usage: run-web path\to\directory
  GOTO :NOOP
)

CALL scripts/get-current-directory.bat
SET currentDir=%returnValue%

PUSHD %1

IF NOT EXIST build\web (
  ECHO WASM not found. run build.bat
  GOTO NOOP
)

SET sheret="%currentDir%\tools\sheret\sheret.exe"
ECHO Running Web...
TASKKILL /IM %sheret% 2> nul
%sheret% -d .\build\web

:NOOP
POPD