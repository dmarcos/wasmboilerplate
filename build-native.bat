@echo off

REM Use system compiler if there's one available
SET compiler="cl"
%compiler% 0> nul 1> nul 2> nul
IF NOT %ERRORLEVEL%==9009 GOTO :BUILD

IF NOT EXIST ".\tools\vs\VC\Tools\MSVC\14.16.27023\bin\Hostx86\x86\cl.exe" (
  echo Visual studio build tools not found. Run setup.bat
  GOTO noop
)

SET compiler="..\tools\vs\VC\Tools\MSVC\14.16.27023\bin\Hostx86\x86\cl.exe"

REM Current directory.
FOR /f "delims=" %%A in ('echo %CD%') do SET templateDir=%%A

REM Drive letter to directory mapping.
FOR /f "delims=" %%A in ('subst') do SET subst="%%A"

REM Deal with driver letter to folder mappings set with subst if any.
if [%subst%]==[] GOTO :SETVARIABLES

REM Extract drive letter from subst.
SET drive=%subst:~1,3%

REM Extract drive expansion from subst. X:\ => C:\Directory\Path
FOR /f "tokens=2 delims=>" %%a in (%subst%) do (SET drivePath=%%a)

REM Trim leading spaces
call :TRIM drivePath %drivePath%
REM append backlash
set drivePath=%drivePath%\

REM Replace Drive letter with drive expansion for current directory.
REM Taken from https://stackoverflow.com/questions/2772456/string-replacement-in-batch-file/2772498
CALL SET templateDir=%%templateDir:%drive%=%drivePath%%%

:SETVARIABLES

if not defined DevEnvDir (
  call "%templateDir%\tools\vs\VC\Auxiliary\Build\vcvars32.bat"
)

:BUILD

IF NOT EXIST .\build\native mkdir .\build\native
PUSHD build\native

%compiler% ..\..\main.cpp

POPD

:TRIM
SETLOCAL EnableDelayedExpansion
SET Params=%*
FOR /f "tokens=1*" %%a in ("!Params!") do ENDLOCAL & SET %1=%%b
EXIT /b

:NOOP

