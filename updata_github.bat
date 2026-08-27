@echo off
cd /d D:\mytool\01_doc\snippet
git pull origin master
git add .
git commit -m "日常更新 [%date% %time%]"
git push origin master
pause