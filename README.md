# Snippet 自动备份工具----本地文件夹之间相互备份

> 一键备份 VS Code 和 Positron 的用户代码片段（snippets）到指定目录，并支持 Git 版本管理。

---

## 📖 项目简介

在日常开发中，我们经常会在 VS Code 或 Positron 中自定义代码片段（snippets）来提升编码效率。这些片段文件通常保存在用户目录深处，手动备份繁琐且容易遗漏。

本工具提供一个**Windows 批处理脚本**，可一键将两个软件的 snippets 文件夹**增量复制**到您指定的备份目录，同时配合 Git 实现版本追踪和云端同步，让您的代码片段永不丢失。

---

## ✨ 主要功能

- ✅ **一键备份** – 双击运行即可，无需任何干预。
- ✅ **增量复制** – 只复制新增或修改的文件，节省时间，已存在的文件不会被删除。
- ✅ **安全可靠** – 不删除任何源文件或备份文件，仅做单向同步。
- ✅ **权限友好** – 避免因管理员权限不足导致的错误。
- ✅ **路径可配** – 轻松修改源目录和备份目录。
- ✅ **Git 集成** – 提供完整的 Git 操作命令，方便版本管理和多设备同步。

---

## 📁 目录结构

```
D:\mytool\01_doc\snippet\
├── backup_snippets.bat          # 主备份脚本
├── vscode_snippet_backup\       # VS Code 备份目标目录
├── positron_snippet_backup\     # Positron 备份目标目录
├── .gitignore                   # Git 忽略文件（可选）
└── README.md                    # 本文档
```

---

## 🚀 使用方法

### 1️⃣ 首次备份

- 双击运行 `backup_snippets.bat`，脚本会自动将源文件夹的内容复制到目标目录。
- 若源文件夹为空（您从未创建过 snippet），备份目录也为空，脚本会给出提示并正常结束。

### 2️⃣ 后续更新

- 每次修改或新增 snippet 后，再次双击脚本即可**增量更新**备份（只复制变化的部分）。
- 脚本窗口会显示复制进度，完成后按任意键关闭。

### 3️⃣ 自定义备份路径

用记事本打开 `backup_snippets.bat`，修改以下 `set` 变量即可：

```batch
set "VSCODE_SOURCE=C:\Users\你的用户名\AppData\Roaming\Code\User\snippets"
set "VSCODE_TARGET=D:\你的备份目录\vscode_snippet_backup"
set "POSITRON_SOURCE=C:\Users\你的用户名\AppData\Roaming\Positron\User\snippets"
set "POSITRON_TARGET=D:\你的备份目录\positron_snippet_backup"
```

---

## 🛠 脚本详解

### 核心命令

```batch
robocopy "%VSCODE_SOURCE%" "%VSCODE_TARGET%" /E /COPY:DAT /R:3 /W:5
```

| 参数 | 说明 |
|------|------|
| `/E` | 复制所有子目录，包括空目录 |
| `/COPY:DAT` | 复制文件数据（Data）、属性（Attributes）和时间戳（Timestamps），不复制审计信息（避免权限错误） |
| `/R:3` | 复制失败时重试 3 次 |
| `/W:5` | 每次重试等待 5 秒 |

### 特点

- 不添加 `/MIR` 或 `/PURGE` 参数，因此**不会删除备份目录中任何已有文件**，只做增量补充。
- 支持中文路径（需将脚本保存为 **ANSI** 编码，以避免乱码）。

---

## 📤 Git 同步指南

本目录已关联 GitHub 仓库，方便您备份脚本及 snippet 文件本身，实现版本控制和多设备同步。

### 首次上传（仅需一次）

```bash
# 1. 配置 Git 用户信息（如未配置）
git config --global user.name "你的GitHub用户名"
git config --global user.email "你的GitHub邮箱"

# 2. 进入仓库目录
cd D:\mytool\01_doc\snippet

# 3. 初始化本地仓库（如未初始化）
git init

# 4. 添加所有文件
git add .

# 5. 提交
git commit -m "snippet 备份1"

# 6. 关联远程仓库
git remote add origin https://github.com/Xieling-123/mytool-snippet.git

# 7. 推送到 GitHub（首次需 -u 建立追踪）
git push -u origin master
```

### 日常更新（每次修改后）

```bash
cd D:\mytool\01_doc\snippet
git status                 # 查看当前改动
git add .                  # 添加所有改动
git commit -m "更新内容：修复脚本错误 / 增加注释等"
git push origin master     # 推送到远程
```

> 💡 如果远程仓库的分支是 `main`，本地是 `master`，可以重命名本地分支：`git branch -M main`，然后 `git push -u origin main`。

---

## ❓ 常见问题

### Q1：运行脚本时提示“没有管理审核的用户权限”
**A**：这是因为之前的版本使用了 `/COPYALL`，现在已改为 `/COPY:DAT`，不会再出现该提示。请使用最新版脚本。

### Q2：备份后目标文件夹里没有文件
**A**：请检查源文件夹（如 `C:\Users\20503\AppData\Roaming\Code\User\snippets`）是否确实有文件。如果从未创建过 snippet，则该文件夹为空，备份结果自然也为空。您可以在软件中先创建至少一个 snippet 再测试。

### Q3：Git 推送时提示 `Recv failure: Connection was reset`
**A**：网络问题，可尝试以下方法：
- 使用 SSH 方式推送：
  ```bash
  git remote set-url origin git@github.com:Xieling-123/mytool-snippet.git
  git push -u origin master
  ```
- 配置代理（如使用 Clash 等）：
  ```bash
  git config --global http.proxy http://127.0.0.1:7890
  git config --global https.proxy http://127.0.0.1:7890
  ```
- 稍后重试或更换网络环境。

### Q4：Git 推送时提示认证失败
**A**：GitHub 已不支持密码认证，需要使用 **Personal Access Token**。在 GitHub Settings → Developer settings → Personal access tokens 生成一个 token，推送时作为密码输入即可。

### Q5：脚本中的中文显示为乱码
**A**：将脚本以 **ANSI** 编码重新保存即可（用记事本打开，另存为，编码选 ANSI）。

---

## 📝 更新日志

- **v1.1** (2026-08-27)  
  - 移除 `/COPYALL`，改用 `/COPY:DAT`，避免权限错误。  
  - 完善注释和文档。

- **v1.0** (2026-08-27)  
  - 初始版本，支持 VS Code 和 Positron 的增量备份。

---

## 📄 许可证

本工具仅供个人学习使用，您可以根据需要自由修改和分发。

---

**Enjoy coding!** 😊
