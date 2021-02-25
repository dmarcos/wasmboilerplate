@ECHO OFF
SETLOCAL EnableDelayedExpansion

REM Current directory.
FOR /f "delims=" %%A in ('echo %CD%') do SET currentDir=%%A

REM Drive letter to directory mapping.
FOR /f "delims=" %%A in ('subst') do SET subst="%%A"

REM Deal with driver letter to folder mappings set with subst if any.
if [%subst%]==[] GOTO :RETURN

REM Extract drive letter from subst.
SET drive=%subst:~1,3%

REM Extract drive expansion from subst. X:\ => C:\Directory\Path
FOR /f "tokens=2 delims=>" %%a in (%subst%) do (SET drivePath=%%a)

REM Trim leading spaces
CALL :TRIM drivePath %drivePath%
REM append backlash
SET drivePath=%drivePath%\

REM Replace Drive letter with drive expansion for current directory.
REM Taken from https://stackoverflow.com/questions/2772456/string-replacement-in-batch-file/2772498
CALL SET currentDir=%%currentDir:%drive%=%drivePath%%%

:RETURN
ENDLOCAL & set returnvalue=%currentDir%
GOTO END

:TRIM
SETLOCAL EnableDelayedExpansion
SET Params=%*
FOR /f "tokens=1*" %%a in ("!Params!") do ENDLOCAL & SET %1=%%b
EXIT /b

:END