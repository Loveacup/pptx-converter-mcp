# PPTX Converter MCP

[English](README.md) | [中文](README.zh-CN.md)

Convert PowerPoint presentations to Markdown with AI-powered image descriptions.

Supports multiple Vision LLM backends: OpenAI, Azure OpenAI, Anthropic, Local models (vLLM, Ollama), and more.

---

## 📢 Acknowledgments

This project is built on top of [Microsoft MarkItDown](https://github.com/microsoft/markitdown), an excellent tool for converting various file formats to Markdown. We extend its functionality by adding:

- AI-powered image description capabilities
- MCP (Model Context Protocol) server support
- Multi-threading and caching optimizations
- Support for multiple Vision LLM providers

---

## Quick Start

### 1. Install

```bash
cd PPTX-Converter-MCP
./install.sh
```

### 2. Configure LLM

```bash
# Copy configuration template
cp .env.example .env

# Edit .env file, set your LLM provider
vim .env
```

### 3. Reload Shell

```bash
source ~/.zshrc  # or ~/.bashrc
```

### 4. Usage

**Single file conversion:**
```bash
pptx-to-md "presentation.pptx" "output.md"
```

**Batch conversion:**
```bash
pptx-batch-convert "/path/to/ppt/folder"
```

**Use in Claude Code:**
```
Please convert presentation.pptx to Markdown
```

---

## Configuration

### Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `LLM_API_URL` | ✅ | LLM API endpoint URL |
| `LLM_MODEL` | ✅ | Model name |
| `LLM_API_KEY` | ❌ | API key (required by some providers) |
| `MAX_WORKERS` | ❌ | Concurrent workers (default: 3) |
| `CACHE_DIR` | ❌ | Cache directory (default: /tmp/ppt_image_cache) |

### Configuration Examples

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

**Local Models (vLLM/Ollama):**
```bash
export LLM_API_URL=http://localhost:8000/v1/chat/completions
export LLM_MODEL=your-model-name
```

For more examples, see [.env.example](.env.example) and [config/llm-config.yaml.example](config/llm-config.yaml.example).

---

## Features

- ✅ Single/Batch PPT conversion
- ✅ AI image descriptions (supports multiple Vision LLMs)
- ✅ Multi-threading for faster processing
- ✅ Smart caching to avoid reprocessing
- ✅ MCP server support for Claude Code

---

## File Structure

```
PPTX-Converter-MCP/
├── bin/                          # Executable tools
│   ├── pptx-to-md               # Single file conversion
│   ├── pptx-batch-convert       # Batch conversion
│   └── pptx-converter-mcp       # MCP server
├── config/
│   ├── mcp.json.template        # MCP configuration template
│   └── llm-config.yaml.example  # LLM configuration reference
├── docs/                         # Documentation
│   ├── README.md
│   └── MCP-DEPLOYMENT.md
├── .env.example                  # Environment variables template
├── examples/                     # Examples
│   └── example.pptx
├── install.sh                   # Installation script
└── README.md                    # This file
```

---

## Requirements

- macOS / Linux
- Python 3.11+
- Any Vision LLM with OpenAI-compatible API

---

## Documentation

- [Full Documentation](docs/README.md)
- [Deployment Guide](docs/MCP-DEPLOYMENT.md)

---

**Version:** 1.1  
**Date:** 2026-02-08
