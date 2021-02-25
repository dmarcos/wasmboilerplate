@echo off

IF NOT EXIST .\build call build.bat

IF "%1"=="" (
  CALL :native
  CALL :web
  GOTO :end
)

IF "%1"=="native" (
  CALL :native
  GOTO :end
)

IF "%1"=="web" (
  CALL :web
  GOTO :end
)

:native
call run-native.bat

:web
call run-web.bat

:noop