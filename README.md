# PPTX Converter MCP

PPT 转 Markdown MCP 服务器，支持 AI 图片描述。

支持多种 Vision LLM 后端：OpenAI、Azure OpenAI、Anthropic、本地模型（vLLM、Ollama）等。

---

## 快速开始

### 1. 安装

```bash
cd PPTX-Converter-MCP
./install.sh
```

### 2. 配置 LLM

```bash
# 复制配置模板
cp .env.example .env

# 编辑 .env 文件，设置你的 LLM 提供商
vim .env
```

### 3. 重新加载 shell

```bash
source ~/.zshrc  # 或 ~/.bashrc
```

### 4. 使用

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

## 配置

### 环境变量

| 变量 | 必需 | 说明 |
|------|------|------|
| `LLM_API_URL` | ✅ | LLM API 端点 URL |
| `LLM_MODEL` | ✅ | 模型名称 |
| `LLM_API_KEY` | ❌ | API 密钥（部分提供商需要） |
| `MAX_WORKERS` | ❌ | 并发数（默认: 3） |
| `CACHE_DIR` | ❌ | 缓存目录（默认: /tmp/ppt_image_cache） |

### 配置示例

**OpenAI:**
```bash
export LLM_API_URL=https://api.openai.com/v1/chat/completions
export LLM_API_KEY=sk-your-api-key
export LLM_MODEL=gpt-4o
```

**Azure OpenAI:**
```bash
export LLM_API_URL=https://your-resource.openai.azure.com/openai/deployments/your-deployment/chat/completions?api-version=2024-02-15-preview
export LLM_API_KEY=your-azure-api-key
export LLM_MODEL=gpt-4o
```

**本地模型 (vLLM/Ollama):**
```bash
export LLM_API_URL=http://localhost:8000/v1/chat/completions
export LLM_MODEL=your-model-name
```

更多配置示例请参阅 [.env.example](.env.example) 和 [config/llm-config.yaml.example](config/llm-config.yaml.example)。

---

## 功能特性

- ✅ 单人/批量 PPT 转换
- ✅ AI 图片描述（支持多种 Vision LLM）
- ✅ 多线程并发处理
- ✅ 智能缓存避免重复处理
- ✅ MCP 服务器支持

---

## 文件说明

```
PPTX-Converter-MCP/
├── bin/                          # 可执行工具
│   ├── pptx-to-md               # 单人转换
│   ├── pptx-batch-convert       # 批量转换
│   └── pptx-converter-mcp       # MCP 服务器
├── config/
│   ├── mcp.json.template        # MCP 配置模板
│   └── llm-config.yaml.example  # LLM 配置参考
├── docs/                         # 文档
│   ├── README.md
│   └── MCP-DEPLOYMENT.md
├── .env.example                  # 环境变量配置模板
├── examples/                     # 示例
│   └── example.pptx
├── install.sh                   # 安装脚本
└── README.md                    # 本文件
```

---

## 系统要求

- macOS / Linux
- Python 3.11+
- 任意支持 OpenAI 兼容 API 的 Vision LLM

---

## 详细文档

- [完整文档](docs/README.md)
- [部署指南](docs/MCP-DEPLOYMENT.md)

---

**版本:** 1.1  
**日期:** 2026-02-08
