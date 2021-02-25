@echo off

IF "%2"=="" (
  CALL :native %1
  CALL :web %1
  GOTO :END
)

IF "%2"=="native" (
  CALL :native %1
  GOTO :END
)

IF "%2"=="web" (
  CALL :web %1
  GOTO :END
)

:native
CALL scripts/run-native.bat %1
EXIT /b

:web
CALL scripts/run-web.bat %1
EXIT /b

:END