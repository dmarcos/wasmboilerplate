@ECHO OFF

echo Building Web version...

where emcc 0> NUL 1 > NUL 2> NUL
IF ERRORLEVEL 1 (
  echo emcc emscripten compiler not found. Run setup.bat
  GOTO noop
)

IF NOT EXIST .\build\web mkdir .\build\web
PUSHD build\web

call emcc ..\..\main.cpp --shell-file ..\..\wasm-shell.html -o index.html

echo Emscripten compilation finished. Run run.bat

POPD

:noop