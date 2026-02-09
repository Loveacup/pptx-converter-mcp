<div align="center">

# 📊 PPTX Converter MCP

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Python 3.11+](https://img.shields.io/badge/Python-3.11%2B-3776AB.svg)](https://www.python.org/)
[![MCP](https://img.shields.io/badge/MCP-Compatible-green.svg)](https://modelcontextprotocol.io/)

Convert PowerPoint presentations to Markdown with **AI-powered image descriptions**.

Works as a CLI tool or an [MCP](https://modelcontextprotocol.io/) server for seamless integration with Claude Code.

[Features](#-features) · [Quick Start](#-quick-start) · [Configuration](#️-configuration) · [中文](README.zh-CN.md)

</div>

---

## ✨ Features

- 🤖 **AI Image Descriptions** — Auto-generates descriptive text for slide images via Vision LLMs
- 🔌 **Multiple LLM Backends** — OpenAI, Azure OpenAI, Anthropic, local models (vLLM, Ollama)
- 📄 **Single & Batch** — Convert one file or an entire folder
- ⚡ **Multi-threaded** — Parallel image analysis for faster conversion
- 💾 **Smart Caching** — Skips already-processed images
- 🔧 **MCP Server** — Use directly within Claude Code as a tool

## 🔄 How It Works

```
┌──────────┐     ┌───────────────┐     ┌────────────┐     ┌──────────┐
│  .pptx   │────>│  MarkItDown   │────>│ Vision LLM │────>│ Markdown │
│  file(s) │     │  (text/layout)│     │  (images)  │     │  output  │
└──────────┘     └───────────────┘     └────────────┘     └──────────┘
```

Text and layout extraction via [Microsoft MarkItDown](https://github.com/microsoft/markitdown), then each embedded image is sent to a Vision LLM for description, merged into clean Markdown output.

## 🚀 Quick Start

### 1. Install

```bash
git clone https://github.com/Loveacup/pptx-converter-mcp.git
cd pptx-converter-mcp
./install.sh
```

### 2. Configure LLM

```bash
cp .env.example .env
vim .env    # set your LLM provider and API key
```

### 3. Reload Shell

```bash
source ~/.zshrc    # or ~/.bashrc
```

### 4. Convert

```bash
# Single file
pptx-to-md "presentation.pptx" "output.md"

# Batch — all .pptx files in a folder
pptx-batch-convert "/path/to/ppt/folder"

# Or use in Claude Code directly:
# > Please convert presentation.pptx to Markdown
```

## ⚙️ Configuration

### Environment Variables

| Variable | Required | Default | Description |
|----------|:--------:|---------|-------------|
| `LLM_API_URL` | ✅ | — | LLM API endpoint URL |
| `LLM_MODEL` | ✅ | — | Model name |
| `LLM_API_KEY` | | — | API key (required by some providers) |
| `MAX_WORKERS` | | `3` | Concurrent threads |
| `CACHE_DIR` | | `/tmp/ppt_image_cache` | Cache directory |

### Provider Examples

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
<summary><b>Local Models (vLLM / Ollama)</b></summary>

```bash
LLM_API_URL=http://localhost:8000/v1/chat/completions
LLM_MODEL=your-model-name
# LLM_API_KEY is not needed for most local setups
```

</details>

See [.env.example](.env.example) and [config/llm-config.yaml.example](config/llm-config.yaml.example) for more configurations.

## 📁 Project Structure

```
pptx-converter-mcp/
├── bin/
│   ├── pptx-to-md              # Single file CLI
│   ├── pptx-batch-convert      # Batch conversion CLI
│   └── pptx-converter-mcp      # MCP server entry point
├── config/
│   ├── mcp.json.template       # MCP config template
│   └── llm-config.yaml.example # LLM config reference
├── docs/
│   ├── README.md               # Full documentation
│   └── MCP-DEPLOYMENT.md       # MCP deployment guide
├── examples/
│   └── example.pptx            # Sample presentation
├── .env.example
├── install.sh                  # One-click installer
└── LICENSE
```

## 📋 Requirements

- macOS or Linux
- Python 3.11+
- A Vision LLM with OpenAI-compatible API

## 📚 Documentation

- [Full Documentation](docs/README.md)
- [MCP Deployment Guide](docs/MCP-DEPLOYMENT.md)

## 🙏 Acknowledgments

Built on [Microsoft MarkItDown](https://github.com/microsoft/markitdown) — an excellent file-to-Markdown conversion library.

## 📄 License

[MIT](LICENSE)
