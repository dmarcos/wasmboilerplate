@ECHO OFF


IF "%2"=="" (
  CALL :native %1
  CALL :web %1
  GOTO :end
)

IF "%2"=="native" (
  CALL :native %1
  GOTO :end
)

IF "%2"=="web" (
  CALL :web %1
  GOTO :end
)

:native
CALL ./scripts/build-native.bat %1
EXIT /b

:web
CALL ./scripts/build-web.bat %1
EXIT /b

:end

