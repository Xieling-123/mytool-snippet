@echo off
cd /d D:\mytool\01_doc\snippet

:: 获取标准时间
for /f "delims=" %%i in ('powershell -Command "Get-Date -Format 'yyyy-MM-dd HH:mm:ss'"') do set "NOW=%%i"

git pull origin master
git add .
git commit -m "Auto backup on %NOW%"
git push origin master
pause