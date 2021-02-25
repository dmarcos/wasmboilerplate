@ECHO OFF

CALL get-current-directory.bat
SET currentDir=%returnValue%
SET sheretDir=".\tools\sheret"
SET serverDownloadDestination="%currentDir%\tools\sheret\sheret.zip"
SET serverURL=https://github.com/ethanpil/sheret/releases/download/1.21/sheret-v1.21.zip
echo %serverDownloadDestination%

IF NOT EXIST .\tools\sheret\sheret.exe (
  IF NOT EXIST "%sheretDir%" mkdir "%sheretDir%"
  CALL bitsadmin /transfer "Downloading Sheret Web Server" /download /priority normal %serverURL% %serverDownloadDestination%
  CALL PUSHD tools\sheret
  CALL tar -xf sheret.zip
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

CALL scripts/install-python.bat

PUSHD tools

CALL git clone https://github.com/emscripten-core/emsdk.git

PUSHD emsdk

CALL .\emsdk install latest

CALL .\emsdk activate latest

:setupenv

CALL .\emsdk_env.bat

POPD
POPD

:noop