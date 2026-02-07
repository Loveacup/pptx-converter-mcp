# PPTX Converter MCP

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Python 3.11+](https://img.shields.io/badge/Python-3.11%2B-3776AB.svg)](https://www.python.org/)
[![MCP Compatible](https://img.shields.io/badge/MCP-Compatible-green.svg)](https://modelcontextprotocol.io/)

[English](README.md) | [中文](README.zh-CN.md)

Convert PowerPoint presentations to Markdown with **AI-powered image descriptions**. Works as a CLI tool or an [MCP](https://modelcontextprotocol.io/) server for seamless integration with Claude Code.

## Features

- **AI Image Descriptions** — Automatically generates descriptive text for images in slides using Vision LLMs
- **Multiple LLM Backends** — OpenAI, Azure OpenAI, Anthropic, local models (vLLM, Ollama), and any OpenAI-compatible API
- **Single & Batch Conversion** — Convert one file or an entire folder in a single command
- **Multi-threaded Processing** — Parallel image analysis for faster conversion
- **Smart Caching** — Skips already-processed images to avoid redundant API calls
- **MCP Server** — Use directly within Claude Code as a tool

## How It Works

```
┌──────────┐     ┌───────────────┐     ┌────────────┐     ┌──────────┐
│  .pptx   │────>│  MarkItDown   │────>│ Vision LLM │────>│ Markdown │
│  file(s) │     │  (text/layout)│     │ (images)   │     │ output   │
└──────────┘     └───────────────┘     └────────────┘     └──────────┘
```

The tool extracts text and layout via [Microsoft MarkItDown](https://github.com/microsoft/markitdown), then sends each embedded image to a Vision LLM for description, and merges everything into a clean Markdown file.

## Quick Start

### 1. Install

```bash
git clone https://github.com/Loveacup/pptx-converter-mcp.git
cd pptx-converter-mcp
./install.sh
```

### 2. Configure LLM

```bash
cp .env.example .env
# Edit .env — set your LLM provider and API key
vim .env
```

### 3. Reload Shell

```bash
source ~/.zshrc  # or ~/.bashrc
```

### 4. Convert

```bash
# Single file
pptx-to-md "presentation.pptx" "output.md"

# Batch — converts all .pptx files in a folder
pptx-batch-convert "/path/to/ppt/folder"

# Or use in Claude Code directly
# > Please convert presentation.pptx to Markdown
```

## Configuration

### Environment Variables

| Variable | Required | Description |
|----------|:--------:|-------------|
| `LLM_API_URL` | Yes | LLM API endpoint URL |
| `LLM_MODEL` | Yes | Model name |
| `LLM_API_KEY` | No | API key (required by some providers) |
| `MAX_WORKERS` | No | Concurrent threads (default: `3`) |
| `CACHE_DIR` | No | Cache directory (default: `/tmp/ppt_image_cache`) |

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

See [.env.example](.env.example) and [config/llm-config.yaml.example](config/llm-config.yaml.example) for more provider configurations.

## Project Structure

```
pptx-converter-mcp/
├── bin/
│   ├── pptx-to-md              # Single file conversion CLI
│   ├── pptx-batch-convert      # Batch conversion CLI
│   └── pptx-converter-mcp      # MCP server entry point
├── config/
│   ├── mcp.json.template       # MCP configuration template
│   └── llm-config.yaml.example # LLM configuration reference
├── docs/
│   ├── README.md               # Full documentation
│   └── MCP-DEPLOYMENT.md       # MCP deployment guide
├── examples/
│   └── example.pptx            # Sample presentation
├── .env.example                # Environment variables template
└── install.sh                  # One-click installer
```

## Requirements

- macOS or Linux
- Python 3.11+
- A Vision LLM with OpenAI-compatible API

## Documentation

- [Full Documentation](docs/README.md)
- [MCP Deployment Guide](docs/MCP-DEPLOYMENT.md)

## Acknowledgments

Built on top of [Microsoft MarkItDown](https://github.com/microsoft/markitdown) — an excellent file-to-Markdown conversion library.

## License

[MIT](LICENSE)
