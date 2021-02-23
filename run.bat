@echo off

IF NOT EXIST .\build call build.bat

pushd build

taskkill /IM main.exe 2> nul
main.exe

popd