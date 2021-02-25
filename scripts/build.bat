@ECHO OFF

REM Make sure we call scripts from expected directory.
IF NOT %0=="scripts\build.bat" (
  PUSHD %~dp0
  CD..
)

IF "%2"=="" (
  CALL :native
  CALL :web
  GOTO :end
)

IF "%2"=="native" (
  CALL :native
  GOTO :end
)

IF "%2"=="web" (
  CALL :web
  GOTO :end
)

:native
CALL scripts/build-native.bat %1
EXIT /b

:web
CALL scripts/build-web.bat %1
EXIT /b

:end

REM Restore original directory if it was changed.
IF NOT %0=="scripts\build.bat" (
  POPD
)

