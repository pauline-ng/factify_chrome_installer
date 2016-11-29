@echo off
cd /d %~dp0

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
