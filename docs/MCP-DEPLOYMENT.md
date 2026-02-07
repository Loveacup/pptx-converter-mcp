# MCP 服务器部署指南

## 部署组件

### 1. MCP 服务器: `pptx-converter`
**路径**: `~/.local/bin/pptx-converter-mcp`
**配置**: `~/.mcp.json`

**功能**:
- `convert_single_pptx` - 单人 PPT 转换（带图片描述）
- `convert_batch_pptx` - 批量 PPT 转换（带图片描述）

### 2. 底层工具
| 工具 | 路径 | 功能 |
|------|------|------|
| `pptx-to-md` | `~/.local/bin/pptx-to-md` | 单人转换 |
| `pptx-batch-convert` | `~/.local/bin/pptx-batch-convert` | 批量转换 |
| `pptx-converter-mcp` | `~/.local/bin/pptx-converter-mcp` | MCP 服务器 |

---

## 配置步骤

### 步骤 1: 设置环境变量

工具需要以下环境变量才能运行：

| 变量 | 必需 | 说明 |
|------|------|------|
| `LLM_API_URL` | ✅ | Vision LLM API 端点 URL |
| `LLM_MODEL` | ✅ | 模型名称 |
| `LLM_API_KEY` | ❌ | API 密钥（部分提供商需要） |
| `MAX_WORKERS` | ❌ | 并发数（默认: 3） |
| `CACHE_DIR` | ❌ | 缓存目录（默认: /tmp/ppt_image_cache） |

### 步骤 2: 配置 MCP

编辑 `~/.mcp.json`，使用你的 LLM 配置替换占位符：

```json
{
  "mcpServers": {
    "pptx-converter": {
      "command": "/opt/homebrew/bin/python3.11",
      "args": ["/Users/YOUR_USERNAME/.local/bin/pptx-converter-mcp"],
      "env": {
        "LLM_API_URL": "YOUR_LLM_API_URL",
        "LLM_API_KEY": "YOUR_LLM_API_KEY",
        "LLM_MODEL": "YOUR_MODEL_NAME",
        "MAX_WORKERS": "3",
        "CACHE_DIR": "/tmp/ppt_image_cache"
      }
    }
  }
}
```

**MCP 配置示例 - OpenAI:**
```json
{
  "mcpServers": {
    "pptx-converter": {
      "command": "/opt/homebrew/bin/python3.11",
      "args": ["/Users/yourname/.local/bin/pptx-converter-mcp"],
      "env": {
        "LLM_API_URL": "https://api.openai.com/v1/chat/completions",
        "LLM_API_KEY": "sk-your-openai-api-key",
        "LLM_MODEL": "gpt-4o",
        "MAX_WORKERS": "3",
        "CACHE_DIR": "/tmp/ppt_image_cache"
      }
    }
  }
}
```

**MCP 配置示例 - 本地模型:**
```json
{
  "mcpServers": {
    "pptx-converter": {
      "command": "/opt/homebrew/bin/python3.11",
      "args": ["/Users/yourname/.local/bin/pptx-converter-mcp"],
      "env": {
        "LLM_API_URL": "http://localhost:8000/v1/chat/completions",
        "LLM_MODEL": "your-local-model",
        "MAX_WORKERS": "3",
        "CACHE_DIR": "/tmp/ppt_image_cache"
      }
    }
  }
}
```

---

## 可用工具

### 工具 1: convert_single_pptx
**描述**: 将单个 PPT 文件转换为 Markdown，包含 AI 图片描述

**参数**:
- `input_path` (required): PPT 文件的完整路径
- `output_path` (optional): 输出 Markdown 文件路径

**示例**:
```json
{
  "input_path": "/path/to/presentation.pptx",
  "output_path": "/path/to/output.md"
}
```

### 工具 2: convert_batch_pptx
**描述**: 批量转换目录中的所有 PPT 文件为 Markdown

**参数**:
- `input_dir` (required): 包含 PPT 文件的目录路径
- `output_dir` (optional): 输出目录路径

**示例**:
```json
{
  "input_dir": "/path/to/ppt/folder",
  "output_dir": "/path/to/output/folder"
}
```

---

## 使用方式

### 方式 1: MCP 客户端（如 Claude Code）
当 MCP 客户端启动时，会自动读取 `~/.mcp.json` 配置，您可以直接调用：

```
请帮我将 /path/to/file.pptx 转换为 Markdown
```

或批量转换：
```
请批量转换 /path/to/ppt/folder 中的所有 PPT 文件
```

### 方式 2: 命令行工具（备用）
如果 MCP 客户端不可用，可以直接使用底层工具：

```bash
# 单人转换
~/.local/bin/pptx-to-md "input.pptx" "output.md"

# 批量转换
~/.local/bin/pptx-batch-convert "/path/to/ppt/folder"
```

---

## 功能特性

### 核心功能
1. **自动提取图片** - 从 PPT 中提取所有图片（PNG/JPG/JPEG/GIF/BMP/WebP）
2. **AI 图片描述** - 使用 Vision LLM 生成详细描述
3. **多线程处理** - 默认 3 并发，提高处理速度
4. **智能缓存** - 避免重复处理相同图片
5. **Markdown 整合** - 将描述自动添加到对应图片下方

### 性能指标
- 单张图片处理时间: 取决于 LLM 提供商
- 并发数: 可配置（默认 3）
- 支持格式: PPTX
- 缓存位置: 可配置

---

## 环境要求

- Python 3.11+
- MCP SDK (`pip install mcp`)
- requests
- markitdown
- 任意支持 OpenAI 兼容 API 的 Vision LLM

---

## 故障排除

### 问题 1: "LLM_API_URL and LLM_MODEL must be set"
**原因**: MCP 配置中未设置必需的环境变量。
**解决**: 编辑 `~/.mcp.json`，确保 `env` 中包含有效的 `LLM_API_URL` 和 `LLM_MODEL`。

### 问题 2: MCP 服务器无法启动
**检查**:
```bash
# 检查依赖
python3.11 -c "from mcp.server import Server; print('OK')"
```

### 问题 3: 工具命令找不到
**解决**:
```bash
export PATH="$HOME/.local/bin:$PATH"
```

### 问题 4: LLM API 连接失败
**检查**:
```bash
# 测试 API 端点
curl -s "$LLM_API_URL" -H "Authorization: Bearer $LLM_API_KEY"
```

### 问题 5: API 返回 401 Unauthorized
**原因**: API 密钥无效或未设置。
**解决**: 确保 `LLM_API_KEY` 设置正确。

---

## 架构图

```
┌─────────────────────────────────────────┐
│           MCP Client                    │
│    (Claude Code / Other Clients)        │
└─────────────┬───────────────────────────┘
              │ JSON-RPC
              ▼
┌─────────────────────────────────────────┐
│       pptx-converter-mcp                │
│    ~/.local/bin/pptx-converter-mcp      │
└─────────────┬───────────────────────────┘
              │ subprocess
              ▼
┌─────────────────────────────────────────┐
│  pptx-to-md  │  pptx-batch-convert     │
│  (单人转换)   │  (批量转换)             │
└──────────────┼──────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────┐
│  Vision LLM API                         │
│  (OpenAI / Azure / Local / etc.)        │
└─────────────────────────────────────────┘
```

---

## 更新日志

### v1.1 (2026-02-08)
- ✅ 支持多种 Vision LLM 后端
- ✅ 移除硬编码的 API 配置
- ✅ 添加环境变量验证

### v1.0 (2024-02-07)
- ✅ 部署自定义 MCP 服务器
- ✅ 整合单人/批量转换功能
- ✅ 支持图片描述生成
