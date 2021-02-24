@echo off

REM Use system compiler if there's one available
SET compiler="clx"
%compiler% 0> nul 1> nul 2> nul
IF NOT %ERRORLEVEL%==9009 GOTO :BUILD

REM call setup.bat

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

SET "INCLUDE1=C:\Program Files (x86)\Windows Kits\NETFXSDK\4.8\include\um"
SET "INCLUDE2=C:\Program Files (x86)\Windows Kits\10\include\10.0.17763.0\ucrt"
SET "INCLUDE3=C:\Program Files (x86)\Windows Kits\10\include\10.0.17763.0\um"
SET "INCLUDE4=C:\Program Files (x86)\Windows Kits\10\include\10.0.17763.0\winrt"
SET "INCLUDE5=C:\Program Files (x86)\Windows Kits\10\include\10.0.17763.0\cppwinrt"
SET "INCLUDE6=%templateDir%\tools\vs\VC\Tools\MSVC\14.16.27023\include"
SET INCLUDE=%INCLUDE1%;%INCLUDE2%;%INCLUDE3%;%INCLUDE4%;%INCLUDE5%;%INCLUDE6%

SET "LIB1=C:\Program Files (x86)\Windows Kits\NETFXSDK\4.8\lib\um\x86"
SET "LIB2=C:\Program Files (x86)\Windows Kits\10\lib\10.0.17763.0\ucrt\x86"
SET "LIB3=C:\Program Files (x86)\Windows Kits\10\lib\10.0.17763.0\um\x86"
SET "LIB3=C:\Program Files (x86)\Windows Kits\10\lib\10.0.17763.0\um\x86"
SET "LIB4=%templateDir%\tools\vs\VC\Tools\MSVC\14.28.27023\ATLMFC\lib\x86"
SET "LIB5=%templateDir%\tools\vs\VC\Tools\MSVC\14.16.27023\lib\x86"
SET LIB=%LIB1%;%LIB2%;%LIB3%;%LIB4%;%LIB5%

:BUILD

IF NOT EXIST .\build mkdir .\build
PUSHD build

%compiler% ..\main.cpp

popd

:TRIM
SETLOCAL EnableDelayedExpansion
SET Params=%*
FOR /f "tokens=1*" %%a in ("!Params!") do ENDLOCAL & SET %1=%%b
EXIT /b


