@echo off
title Snippet Backup Tool
echo Start backup...


set "VSCODE_SOURCE=C:\Users\20503\AppData\Roaming\Code\User\snippets"
set "VSCODE_TARGET=D:\mytool\01_doc\snippet\vscode_snippet_backup"
set "POSITRON_SOURCE=C:\Users\20503\AppData\Roaming\Positron\User\snippets"
set "POSITRON_TARGET=D:\mytool\01_doc\snippet\positron_snippet_backup"


if exist "%VSCODE_SOURCE%" (
    echo Backing up VS Code snippets...
    robocopy "%VSCODE_SOURCE%" "%VSCODE_TARGET%" /E /COPY:DAT /R:3 /W:5
    echo VS Code backup done.
) else (
    echo Warning: VS Code source folder not found, skipped.
)

if exist "%POSITRON_SOURCE%" (
    echo Backing up Positron snippets...
    robocopy "%POSITRON_SOURCE%" "%POSITRON_TARGET%" /E /COPY:DAT /R:3 /W:5
    echo Positron backup done.
) else (
    echo Warning: Positron source folder not found, skipped.
)

echo All operations finished.

pause