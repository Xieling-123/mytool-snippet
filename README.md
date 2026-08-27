# Snippet 自动备份工具

> 一键备份 VS Code 和 Positron 的用户代码片段（snippets）到指定目录，并自动同步到 GitHub。

---

## 📖 项目简介

在日常开发中，我们经常会在 VS Code 或 Positron 中自定义代码片段（snippets）来提升编码效率。这些片段文件通常保存在用户目录深处，手动备份繁琐且容易遗漏。

本工具集提供一套**完整的自动化工作流**：
- **本地备份**：一键将两个软件的 snippets 文件夹增量复制到指定目录
- **云端同步**：自动提交并推送到 GitHub，实现版本追溯和多设备同步
- **定时执行**：每天 12:00、18:00、0:00 自动运行，无需人工干预

---

## ✨ 功能特性

- ✅ **一键备份** – 双击运行即可，无需任何干预
- ✅ **增量复制** – 只复制新增或修改的文件，节省时间，已存在的文件不会被删除
- ✅ **安全可靠** – 不删除任何源文件或备份文件，仅做单向同步
- ✅ **权限友好** – 使用 `/COPY:DAT`，避免因管理员权限不足导致的错误
- ✅ **Git 自动同步** – 提交并推送到 GitHub，历史版本可追溯
- ✅ **全自动定时执行** – 每天三次（12:00、18:00、0:00），无人值守
- ✅ **完整日志记录** – 每次执行都记录到 `C:\backup_log.txt`，方便排查问题
- ✅ **路径可配置** – 轻松修改源目录和备份目录

---

## 📁 目录结构

```
D:\mytool\01_doc\snippet\
├── backup_snippets.bat           # 基础备份脚本（仅本地复制）
├── auto_backup_and_push.bat      # 全能备份脚本（备份 + Git 推送，带日志）
├── git_sync.bat                  # 日常 Git 同步工具（拉取 + 提交 + 推送）
├── init_git_repo.txt             # 新项目首次上传 GitHub 的通用模版
├── vscode_snippet_backup\        # VS Code 备份目标目录
├── positron_snippet_backup\      # Positron 备份目标目录
├── .gitignore                    # Git 忽略文件
└── README.md                     # 本文档
```

---

## 🚀 快速开始

### 1️⃣ 首次使用（仅需一次）

#### 配置 Git 用户信息（如果未配置过）
```bash
git config --global user.name "你的GitHub用户名"
git config --global user.email "你的GitHub邮箱"
```

#### 设置 Git 默认编辑器为记事本（避免命令行卡住）
```bash
git config --global core.editor notepad
```

#### 克隆或初始化仓库
```bash
cd D:\mytool\01_doc\snippet
git init
git add .
git commit -m "snippet 备份1"
git remote add origin https://github.com/Xieling-123/mytool-snippet.git
git push -u origin master
```

### 2️⃣ 日常使用

#### 方式一：手动备份（双击运行）
- **`backup_snippets.bat`** – 仅本地备份，不推送 Git
- **`auto_backup_and_push.bat`** – 备份 + 自动提交 + 推送到 GitHub
- **`git_sync.bat`** – 仅 Git 同步（拉取最新 → 提交本地变更 → 推送）

#### 方式二：全自动定时执行（推荐）
配置 Windows 任务计划程序，每天 12:00、18:00、0:00 自动执行 `auto_backup_and_push.bat`。详见下方 **定时任务配置** 章节。

---

## 🛠 脚本详解

### `backup_snippets.bat` – 基础备份脚本

```batch
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
```

**核心命令说明：**
- `robocopy` – Windows 自带的高效文件复制工具
- `/E` – 复制所有子目录（包括空目录）
- `/COPY:DAT` – 复制文件数据、属性和时间戳（不涉及审计信息，避免权限错误）
- `/R:3` – 失败时重试 3 次
- `/W:5` – 每次重试等待 5 秒

### `auto_backup_and_push.bat` – 全能备份脚本

相比基础脚本，增加以下功能：
- ✅ 自动 `git pull` 拉取远程最新变更
- ✅ 自动 `git add .` + `git commit`（带时间戳）
- ✅ 自动 `git push` 推送到 GitHub
- ✅ 完整日志记录到 `C:\backup_log.txt`
- ✅ 无交互界面，适合无人值守运行

### `git_sync.bat` – 日常 Git 同步工具

```batch
@echo off
cd /d D:\mytool\01_doc\snippet
git pull --no-edit origin master
git add .
git commit -m "日常同步更新 [%date% %time%]"
git push origin master
pause
```

**适用场景**：当你修改了仓库中的任何文件（README、脚本等），需要快速同步到 GitHub 时，双击运行即可。

---

## ⏰ 定时任务配置

### 配置步骤（以中午 12:00 为例）

1. 按 `Win + R`，输入 `taskschd.msc`，回车打开 **任务计划程序**。
2. 右侧点击 **创建基本任务**。
3. **名称**：输入 `Snippet备份-中午`。
4. **触发器**：选择 **每天**，开始时间设为 `12:00:00`。
5. **操作**：选择 **启动程序**。
   - **程序或脚本**：`C:\Windows\System32\cmd.exe`
   - **添加参数**：`/c "D:\mytool\01_doc\snippet\auto_backup_and_push.bat"`
   - **起始于**：`D:\mytool\01_doc\snippet`
6. 点击 **完成**。

### 三个定时任务

| 任务名称 | 执行时间 | 脚本 |
|---------|---------|------|
| `Snippet备份-中午` | 每天 12:00 | `auto_backup_and_push.bat` |
| `Snippet备份-下午` | 每天 18:00 | `auto_backup_and_push.bat` |
| `Snippet备份-凌晨` | 每天 0:00 | `auto_backup_and_push.bat` |

### 高级设置（避免权限问题）

在任务列表中右键任务 → **属性**：
- **常规** → 勾选 **不管用户是否登录都要运行**
- **常规** → 勾选 **使用最高权限运行**
- **条件** → 取消勾选 **只有在计算机使用交流电源时才启动此任务**

---

## ❓ 常见问题

### Q1：运行脚本时提示“没有管理审核的用户权限”
**A**：新版脚本已改用 `/COPY:DAT`，不会再出现此提示。请确保使用最新版本。

### Q2：备份后目标文件夹里没有文件
**A**：检查源文件夹（如 `C:\Users\20503\AppData\Roaming\Code\User\snippets`）是否真的有文件。如果从未创建过 snippet，则该文件夹为空，备份结果自然也为空。

### Q3：Git 推送时提示 `rejected`（推送被拒绝）
**A**：原因是远程仓库有新的提交，但本地没有。执行 `git pull origin master` 先拉取远程变更，再执行 `git push origin master`。新版本的 `auto_backup_and_push.bat` 已内置 `git pull` 步骤，会自动处理。

### Q4：Git 推送时提示 `Recv failure: Connection was reset`
**A**：网络问题，可尝试：
- 使用 SSH 方式推送：
  ```bash
  git remote set-url origin git@github.com:Xieling-123/mytool-snippet.git
  ```
- 配置代理（如使用 Clash）：
  ```bash
  git config --global http.proxy http://127.0.0.1:7890
  git config --global https.proxy http://127.0.0.1:7890
  ```

### Q5：脚本中的中文显示为乱码
**A**：用记事本打开脚本，另存为时选择 **ANSI** 编码，覆盖保存即可。

### Q6：任务计划程序执行但脚本没生效
**A**：检查以下几点：
- 脚本路径是否绝对路径（不要用相对路径）
- `起始于` 是否填写了正确的目录
- 是否勾选了 **不管用户是否登录都要运行**
- 查看 `C:\backup_log.txt` 日志文件确认执行情况

### Q7：如何查看每次备份的执行记录？
**A**：所有执行日志都记录在 `C:\backup_log.txt` 中。打开即可看到每次运行的开始时间、结束时间以及各步骤的详细信息。

---

## 🧠 通用 Git 工作流模版

### 首次建立远程仓库（`init_git_repo.txt`）

```bash
:: ============================================================
:: 【通用模版】首次将本地项目上传到 GitHub（新项目初始化）
:: 用法：复制下面命令，替换掉方括号【】里的内容即可
:: ============================================================

git config --global user.name "你的GitHub用户名"
git config --global user.email "你的GitHub邮箱"

cd /d 【你的本地项目文件夹路径】

git init
git add .
git commit -m "首次提交"
git remote add origin 【你的GitHub仓库地址】
git push -u origin master
```

### 日常 Git 同步（`git_sync.bat`）

```batch
:: ============================================================
:: 日常 Git 同步（先拉再推，避免冲突）
:: ============================================================

cd /d 【你的本地项目文件夹路径】
git pull --no-edit origin master
git add .
git commit -m "日常更新 [%date% %time%]"
git push origin master
```

---

## 📝 更新日志

### v2.0 (2026-08-27)
- 整合 `auto_backup_and_push.bat`，实现备份 + Git 推送一体化
- 增加完整日志记录（`C:\backup_log.txt`）
- 优化 Git 操作顺序（先 `pull` 再 `commit`，避免冲突）
- 完善定时任务配置指南

### v1.1 (2026-08-27)
- 移除 `/COPYALL`，改用 `/COPY:DAT`，避免权限错误
- 完善注释和文档

### v1.0 (2026-08-27)
- 初始版本，支持 VS Code 和 Positron 的增量备份

---

## 📄 许可证

本工具仅供个人学习使用，您可以根据需要自由修改和分发。

---

## 🙏 致谢

本工具基于以下技术构建：
- **robocopy** – Windows 自带的可靠文件复制工具
- **Git** – 分布式版本控制系统
- **PowerShell** – Windows 自动化脚本环境
- **Windows 任务计划程序** – 定时任务调度

---

**Enjoy coding!** 😊

---

*如果本工具对你有帮助，欢迎 Star ⭐ 支持！*
