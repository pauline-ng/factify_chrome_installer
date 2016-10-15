@echo off
cd /d %~dp0

:: Step 1: Check Java version 1.8+

java -version 1>nul 2>nul || (
   echo no java installed
   echo please install the latest java:
   echo https://www.java.com/download/
   start "" https://www.java.com/download/
   set /p answer="Press any key to exit"
   exit /b 1
)
for /f tokens^=2-5^ delims^=.-_^" %%j in ('java -fullversion 2^>^&1') do set "jver=%%j%%k%%l%%m"

if %jver% LSS 180000 (
  echo java version is too low
  echo please install the latest java:
  echo https://www.java.com/download/
  start "" https://www.java.com/download/
  set /p answer="Press any key to exit"
  exit /b 1
)

echo Proper Java version is installed. & echo.


:: Step 2: Ask user to installation.

set TMPDIR=%USERPROFILE%\.factpub\chrome_extension_host_program
:: echo Host program will be saved under:
:: echo %TMPDIR%

echo The host program requires 42MB of your disk space.
set /p answer="Do you want to download and setup?(y/n): %answer%"
if "%answer%"=="y" (
  echo Downloading the host program...
) else (
  exit /b 1
)
endlocal

:: Step 3: Create factpub folder under %USERPROFILE%

mkdir %TMPDIR%

:: Step 4: Download necessary files from factpub.org to the working folder

bitsadmin.exe /transfer "TEST" http://factpub.org/ %TMPDIR%/test.html

bitsadmin.exe /transfer "_org.factpub.factify.win.json" http://factpub.org/public/factify_ChromeExtension/install_scripts_win/_org.factpub.factify.win.json %TMPDIR%/_org.factpub.factify.win.json
bitsadmin.exe /transfer "_factify_launcher.bat" http://factpub.org/public/factify_ChromeExtension/install_scripts_win/_factify_launcher.bat %TMPDIR%/_factify_launcher.bat
bitsadmin.exe /transfer "_factify.jar" http://factpub.org/public/factify_ChromeExtension/_factify.jar %TMPDIR%/_factify.jar
bitsadmin.exe /transfer "_register_host_program.bat" http://factpub.org/public/factify_ChromeExtension/install_scripts_win/_register_host_program.bat %TMPDIR%/_register_host_program.bat
bitsadmin.exe /transfer "_unregister_host_program.bat" http://factpub.org/public/factify_ChromeExtension/install_scripts_win/_unregister_host_program.bat %TMPDIR%/_unregister_host_program.bat

:: Step 5: Add host program to registry.
call %TMPDIR%\_register_host_program.bat

:: Step 6: Wait till user input and close.
set /p answer="Setup is done. (Press any key to close)"
if "%answer%"=="y" (
  exit /b 1
) else (
  exit /b 1
)
endlocal
