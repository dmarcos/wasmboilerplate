@ECHO off

IF NOT EXIST %1 (
  ECHO Project directory not found.
  ECHO USAGE: run path/to/project
  GOTO END
)

IF "%2"=="" (
  CALL :NATIVE %1
  CALL :WEB %1
  GOTO :END
)

IF "%2"=="native" (
  CALL :NATIVE %1
  GOTO :END
)

IF "%2"=="web" (
  CALL :WEB %1
  GOTO :END
)

:NATIVE
CALL scripts/run-native.bat %1
EXIT /b

:WEB
CALL scripts/run-web.bat %1
EXIT /b

:END