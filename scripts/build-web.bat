@ECHO OFF

ECHO Building Web version...

IF "%1"=="" (
  ECHO Error. Project directory not specified.
  ECHO.
  ECHO Usage: build-web path\to\directory
  GOTO :NOOP
)

REM Make sure we call scripts from expected directory.
IF NOT %0=="scripts\build-web.bat" (
  PUSHD %~dp0
  CD..
)

WHERE emcc 0> NUL 1> NUL 2> NUL
IF ERRORLEVEL 1 (
  IF EXIST .\tools\emsdk\emsdk_env.bat (
    CALL .\tools\emsdk\emsdk_env.bat
  ) ELSE (
    echo emcc emscripten compiler not found. Run setup.bat
    GOTO NOOP
  )
)

CALL scripts/get-current-directory.bat
SET currentDir=%returnValue%

PUSHD %1
SET mainFile=main.cpp
IF EXIST "wasm-main.cpp" SET mainFile=wasm-main.cpp

IF NOT EXIST .\build\web mkdir .\build\web
CD build\web

CALL emcc "..\..\%mainFile%" -s EXPORTED_RUNTIME_METHODS=['ccall'] --shell-file ..\..\wasm-shell.html -o index.html

ECHO Emscripten compilation finished. Run run.bat

POPD

ECHO Web build done!

:NOOP
IF NOT %0=="scripts\build-web.bat" (
  POPD
)
REM new line.
echo.