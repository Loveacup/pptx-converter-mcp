# PPTX Converter MCP

🚀 PPT 转 Markdown MCP 服务器，支持 AI 图片描述

使用本地 Qwen3-VL-32B 模型自动生成图片说明。

---

## 快速开始

### 1. 安装

```bash
cd PPTX-Converter-MCP
./install.sh
```

### 2. 重新加载 shell

```bash
source ~/.zshrc  # 或 ~/.bashrc
```

### 3. 使用

**单人转换:**
```bash
pptx-to-md "presentation.pptx" "output.md"
```

**批量转换:**
```bash
pptx-batch-convert "/path/to/ppt/folder"
```

**在 Claude Code 中使用:**
```
请帮我将 presentation.pptx 转换为 Markdown
```

---

## 功能特性

- ✅ 单人/批量 PPT 转换
- ✅ AI 图片描述（本地 Qwen3-VL-32B）
- ✅ 多线程并发处理
- ✅ 智能缓存避免重复处理
- ✅ MCP 服务器支持

---

## 文件说明

```
PPTX-Converter-MCP/
├── bin/                      # 可执行工具
│   ├── pptx-to-md           # 单人转换
│   ├── pptx-batch-convert   # 批量转换
│   └── pptx-converter-mcp   # MCP 服务器
├── config/
│   └── mcp.json.template    # MCP 配置模板
├── docs/                     # 文档
│   ├── README.md
│   └── MCP-DEPLOYMENT.md
├── examples/                 # 示例
│   └── example.pptx
├── install.sh               # 安装脚本
└── README.md                # 本文件
```

---

## 系统要求

- macOS / Linux
- Python 3.11+
- 本地 LLM API (http://172.16.27.10:9998)

---

## 详细文档

- [完整文档](docs/README.md)
- [部署指南](docs/MCP-DEPLOYMENT.md)

---

**版本:** 1.0  
**日期:** 2024-02-08
