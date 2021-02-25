@ECHO off

ECHO Building Native version...

REM Make sure we call scripts from expected directory.
IF NOT %0=="scripts\build-native.bat" (
  PUSHD %~dp0
  CD..
)

IF "%1"=="" (
  ECHO Error. Project directory not specified.
  ECHO.
  ECHO Usage: build-native path\to\directory
  GOTO :NOOP
)

REM Use system compiler if there's one available
SET compiler="cl"
%compiler% 0> nul 1> nul 2> nul
IF NOT %ERRORLEVEL%==9009 GOTO :BUILD

IF NOT EXIST ".\tools\vs\VC\Tools\MSVC\14.16.27023\bin\Hostx86\x86\cl.exe" (
  ECHO Visual studio build tools not found. Run setup.bat
  GOTO NOOP
)

CALL scripts/get-current-directory.bat
SET currentDir=%returnValue%

IF NOT DEFINED DevEnvDir (
  call "%currentDir%\tools\vs\VC\Auxiliary\Build\vcvars32.bat"
)

SET compiler="%currentDir%\tools\vs\VC\Tools\MSVC\14.16.27023\bin\Hostx86\x86\cl.exe"

:BUILD

PUSHD %1
IF NOT EXIST .\build\native mkdir .\build\native
CD build\native

ECHO "%CD%\..\..\main.cpp"

%compiler% -nologo ..\..\main.cpp

POPD

ECHO Native build done!

:NOOP
IF NOT %0=="scripts\build-native.bat" (
  POPD
)

REM new line.
ECHO.



