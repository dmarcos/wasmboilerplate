@echo off

SET compiler="..\tools\VC\Tools\MSVC\14.16.27023\bin\Hostx86\x86\cl.exe"

pushd tools\VC\Auxiliary\Build
call vcvars32.bat
popd

SET "INCLUDE1=C:\Program Files (x86)\Windows Kits\NETFXSDK\4.8\include\um"
SET "INCLUDE2=C:\Program Files (x86)\Windows Kits\10\include\10.0.18362.0\ucrt"
SET "INCLUDE3=C:\Program Files (x86)\Windows Kits\10\include\10.0.18362.0\um"
SET "INCLUDE4=C:\Program Files (x86)\Windows Kits\10\include\10.0.18362.0\winrt"
SET "INCLUDE5=C:\Program Files (x86)\Windows Kits\10\include\10.0.18362.0\cppwinrt"
SET "INCLUDE6=C:\Users\Diego Marcos\Development\wasmtemplate\tools\VC\Tools\MSVC\14.16.27023\include"
SET INCLUDE=%INCLUDE1%;%INCLUDE2%;%INCLUDE3%;%INCLUDE4%;%INCLUDE5%;%INCLUDE6%

IF NOT EXIST .\build mkdir .\build
pushd build

%compiler% ..\main.cpp

popd