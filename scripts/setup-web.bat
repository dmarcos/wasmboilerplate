@ECHO OFF

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