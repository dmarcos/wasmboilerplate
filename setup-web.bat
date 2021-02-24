@ECHO OFF

IF NOT EXIST .\tools\sheret\sheret.exe (
  SET sheretDir=".\tools\sheret"
  IF NOT EXIST "%sheretDir%" mkdir "%sheretDir%"
  SET serverURL=https://github.com/ethanpil/sheret/releases/download/1.21/sheret-v1.21.zip
  SET serverDownloadDestination="C:\Users\Diego Marcos\Development\wasmtemplate\tools\sheret\sheret.zip"

  REM powershell "Import-Module BitsTransfer; Start-BitsTransfer '%mongooseURL%' '%mongooseDownloadDestination%'"
  bitsadmin /transfer "Downloading Mongoose Web Server" /download /priority high %serverURL% %serverDownloadDestination%
  PUSHD tools\sheret
  tar -xf sheret.zip
  POPD
)

WHERE emcc 0> NUL 1 > NUL 2> NUL
IF NOT ERRORLEVEL 1 (
  ECHO emcc emscripten compiler found. You are all set.
  GOTO noop
)

IF EXIST .\tools\emsdk\emsdk.bat (
  PUSHD tools
  PUSHD emsdk
  GOTO :setupenv
)

IF NOT EXIST .\tools mkdir .\tools
PUSHD tools

git clone https://github.com/emscripten-core/emsdk.git

PUSHD emsdk

CALL .\emsdk install latest

CALL .\emsdk activate latest

:setupenv

CALL .\emsdk_env.bat

POPD
POPD

:noop