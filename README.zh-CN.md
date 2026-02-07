# PPTX Converter MCP

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Python 3.11+](https://img.shields.io/badge/Python-3.11%2B-3776AB.svg)](https://www.python.org/)
[![MCP Compatible](https://img.shields.io/badge/MCP-Compatible-green.svg)](https://modelcontextprotocol.io/)

[English](README.md) | [中文](README.zh-CN.md)

将 PowerPoint 演示文稿转换为 Markdown，**自动生成 AI 图片描述**。既可作为命令行工具使用，也可作为 [MCP](https://modelcontextprotocol.io/) 服务器无缝集成到 Claude Code 中。

## 功能特性

- **AI 图片描述** — 自动调用 Vision LLM 为幻灯片中的图片生成描述文本
- **多 LLM 后端支持** — OpenAI、Azure OpenAI、Anthropic、本地模型（vLLM、Ollama）及任意 OpenAI 兼容 API
- **单文件 & 批量转换** — 一条命令转换单个文件或整个文件夹
- **多线程并发** — 并行处理图片分析，大幅提升转换速度
- **智能缓存** — 跳过已处理的图片，避免重复调用 API
- **MCP 服务器** — 可直接在 Claude Code 中作为工具调用

## 工作原理

```
┌──────────┐     ┌───────────────┐     ┌────────────┐     ┌──────────┐
│  .pptx   │────>│  MarkItDown   │────>│ Vision LLM │────>│ Markdown │
│  文件     │     │  (文本/布局)   │     │ (图片描述)  │     │ 输出      │
└──────────┘     └───────────────┘     └────────────┘     └──────────┘
```

工具通过 [Microsoft MarkItDown](https://github.com/microsoft/markitdown) 提取文本和布局，然后将每张嵌入图片发送给 Vision LLM 生成描述，最终合并为完整的 Markdown 文件。

## 快速开始

### 1. 安装

```bash
git clone https://github.com/Loveacup/pptx-converter-mcp.git
cd pptx-converter-mcp
./install.sh
```

### 2. 配置 LLM

```bash
cp .env.example .env
# 编辑 .env 文件，设置 LLM 提供商和 API 密钥
vim .env
```

### 3. 重新加载 Shell

```bash
source ~/.zshrc  # 或 ~/.bashrc
```

### 4. 开始转换

```bash
# 单文件转换
pptx-to-md "presentation.pptx" "output.md"

# 批量转换 — 转换文件夹内所有 .pptx 文件
pptx-batch-convert "/path/to/ppt/folder"

# 或在 Claude Code 中直接使用
# > 请帮我将 presentation.pptx 转换为 Markdown
```

## 配置说明

### 环境变量

| 变量 | 必需 | 说明 |
|------|:----:|------|
| `LLM_API_URL` | 是 | LLM API 端点 URL |
| `LLM_MODEL` | 是 | 模型名称 |
| `LLM_API_KEY` | 否 | API 密钥（部分提供商需要） |
| `MAX_WORKERS` | 否 | 并发线程数（默认: `3`） |
| `CACHE_DIR` | 否 | 缓存目录（默认: `/tmp/ppt_image_cache`） |

### 提供商配置示例

<details>
<summary><b>OpenAI</b></summary>

```bash
LLM_API_URL=https://api.openai.com/v1/chat/completions
LLM_API_KEY=sk-your-api-key
LLM_MODEL=gpt-4o
```
</details>

<details>
<summary><b>Azure OpenAI</b></summary>

```bash
LLM_API_URL=https://your-resource.openai.azure.com/openai/deployments/your-deployment/chat/completions?api-version=2024-02-15-preview
LLM_API_KEY=your-azure-api-key
LLM_MODEL=gpt-4o
```
</details>

<details>
<summary><b>本地模型（vLLM / Ollama）</b></summary>

```bash
LLM_API_URL=http://localhost:8000/v1/chat/completions
LLM_MODEL=your-model-name
# 大多数本地部署无需设置 LLM_API_KEY
```
</details>

更多配置示例请参阅 [.env.example](.env.example) 和 [config/llm-config.yaml.example](config/llm-config.yaml.example)。

## 项目结构

```
pptx-converter-mcp/
├── bin/
│   ├── pptx-to-md              # 单文件转换 CLI
│   ├── pptx-batch-convert      # 批量转换 CLI
│   └── pptx-converter-mcp      # MCP 服务器入口
├── config/
│   ├── mcp.json.template       # MCP 配置模板
│   └── llm-config.yaml.example # LLM 配置参考
├── docs/
│   ├── README.md               # 完整文档
│   └── MCP-DEPLOYMENT.md       # MCP 部署指南
├── examples/
│   └── example.pptx            # 示例演示文稿
├── .env.example                # 环境变量模板
└── install.sh                  # 一键安装脚本
```

## 系统要求

- macOS 或 Linux
- Python 3.11+
- 任意支持 OpenAI 兼容 API 的 Vision LLM

## 详细文档

- [完整文档](docs/README.md)
- [MCP 部署指南](docs/MCP-DEPLOYMENT.md)

## 致谢

本项目基于 [Microsoft MarkItDown](https://github.com/microsoft/markitdown) 构建 — 一个优秀的文件格式转 Markdown 工具。

## 许可证

[MIT](LICENSE)
