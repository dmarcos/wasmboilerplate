@echo off

IF NOT EXIST .\build call build.bat

IF "%1"=="" (
  CALL :native
  CALL :web
  GOTO :end
)

IF "%1"=="native" (
  CALL :native
  GOTO :end
)

IF "%1"=="web" (
  CALL :web
  GOTO :end
)

:native
taskkill /IM build\native\main.exe 2> nul
build\native\main.exe

:web
taskkill /IM tools\sheret\sheret.exe 2> nul
tools\sheret\sheret.exe -d .\build\web

:noop