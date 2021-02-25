@ECHO OFF

REM Make sure we call scripts from expected directory.
IF NOT %0=="scripts\setup.bat" (
  PUSHD %~dp0
  CD..
)

CALL scripts/setup-native.bat
CALL scripts/setup-web.bat

REM Restore original directory if it was changed.
IF NOT %0=="scripts\setup.bat" (
  POPD
)

