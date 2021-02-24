@ECHO OFF

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
CALL build-native.bat
EXIT /b

:web
CALL build-web.bat
EXIT /b

:end
