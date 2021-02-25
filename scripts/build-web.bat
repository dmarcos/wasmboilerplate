@ECHO OFF

ECHO Building Web version...

WHERE emcc 0> NUL 1 > NUL 2> NUL
IF ERRORLEVEL 1 (
  IF EXIST .\tools\emsdk\emsdk_env.bat (
    CALL .\tools\emsdk\emsdk_env.bat
  ) ELSE (
    echo emcc emscripten compiler not found. Run setup.bat
    GOTO NOOP
  )
)

IF NOT EXIST .\build\web mkdir .\build\web
PUSHD build\web

CALL emcc ..\..\main.cpp --shell-file ..\..\wasm-shell.html -o index.html

ECHO Emscripten compilation finished. Run run.bat

POPD

:NOOP
REM new line.
echo.