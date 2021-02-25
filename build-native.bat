@echo off
SETLOCAL

echo Building Native version...

REM Use system compiler if there's one available
SET compiler="cl"
%compiler% 0> nul 1> nul 2> nul
IF NOT %ERRORLEVEL%==9009 GOTO :BUILD

IF NOT EXIST ".\tools\vs\VC\Tools\MSVC\14.16.27023\bin\Hostx86\x86\cl.exe" (
  echo Visual studio build tools not found. Run setup.bat
  GOTO NOOP
)

SET compiler="..\..\tools\vs\VC\Tools\MSVC\14.16.27023\bin\Hostx86\x86\cl.exe"

CALL get-current-directory.bat
SET currentDir=%returnValue%

IF NOT DEFINED DevEnvDir (
  call "%currentDir%\tools\vs\VC\Auxiliary\Build\vcvars32.bat"
)

:BUILD

IF NOT EXIST .\build\native mkdir .\build\native
PUSHD build\native

%compiler% -nologo ..\..\main.cpp

POPD

:TRIM
SETLOCAL EnableDelayedExpansion
SET Params=%*
FOR /f "tokens=1*" %%a in ("!Params!") do ENDLOCAL & SET %1=%%b
EXIT /b

:NOOP

ENDLOCAL

REM new line.
echo.

