@echo off
cd /d %~dp0

:: Step 1: Check Java version 1.8+
::PATH %PATH%;%JAVA_HOME%\bin\

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


:: Step 2: Ask user to installation.

set file="_factify.jar"

FOR /F "usebackq" %%A IN ('%file%') DO set /A size=%%~zA/1024/1024

:: echo Java version 1.8+ is installed.

echo This program requires %size%MB on your disk space.
set /p answer="Do you want to install it?(y/n): %answer%"
if "%answer%"=="y" (
  echo "start"
) else if "%answer%"=="n" ( 
  echo "cancel"
  exit /b 1
)else (
  echo "other key"
  exit /b 1
)
endlocal

:: Step 3: Create factpub folder under %USERPROFILE%
echo Your home directory is %USERPROFILE%
set TMPDIR=%USERPROFILE%\.factpub\chrome_extension_host_program
mkdir %TMPDIR%
echo Working directory is created : %TMPDIR%

:: Step 4: Copy files to working folder
copy _* %TMPDIR%

:: Step 5: Add host program to registry.
call %TMPDIR%\_register_host_program.bat