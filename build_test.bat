SET MODE="Release"
SET TOPSRCDIR=%cd%
SET VERB=Build
if NOT "%1" == "" SET VERB="%1"

rem call build_sdk.bat || goto :error
cd %TOPSRCDIR%

for /f "usebackq delims=#" %%a in (`"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere" -version 16 -property installationPath`) do call "%%a\VC\Auxiliary\Build\vcvarsall.bat" x64
if %ERRORLEVEL% NEQ 0 goto :error

msbuild ".\npcap-sdk\Examples-pcap\MakeAll.sln" /m /t:%VERB% /p:Configuration=%MODE% /p:Platform="x64" || goto :error
msbuild ".\npcap-sdk\Examples-remote\sendcap\sendcap.vcxproj" /m /t:%VERB% /p:Configuration=%MODE% /p:Platform="x64" || goto :error
if NOT "%VERB%" == "Build" exit /b

copy /b ".\npcap-sdk\Examples-pcap\x64\%MODE%\iflist.exe" test\
copy /b ".\npcap-sdk\Examples-pcap\x64\%MODE%\pcap_filter.exe" test\
copy /b ".\npcap-sdk\Examples-pcap\x64\%MODE%\sendpack.exe" test\
copy /b ".\npcap-sdk\Examples-pcap\x64\%MODE%\readfile.exe" test\

copy /b ".\npcap-sdk\Examples-remote\sendcap\x64\%MODE%\sendcap.exe" test\

exit /b

:error
echo Something failed: %ERRORLEVEL%
exit /b 1
