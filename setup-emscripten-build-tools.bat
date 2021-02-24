@ECHO OFF


WHERE emcc 0> NUL 1 > NUL 2> NUL
IF NOT ERRORLEVEL 1 (
  ECHO emcc emscripten compiler found. You are all set.
  GOTO noop
)

IF EXIST .\tools\emsdk\emsdk.git (
  PUSHD tools
  PUSHD emsdk
  GOTO :setup
)

IF NOT EXIST .\tools mkdir .\tools
PUSHD tools

git clone https://github.com/emscripten-core/emsdk.git

PUSHD emsdk

:setup

CALL .\emsdk install latest

CALL .\emsdk activate latest

CALL .\emsdk_env.bat

POPD
POPD

:noop