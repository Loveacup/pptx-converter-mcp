# 完整配置指南 - PPT 转 Markdown 工具

## 已安装的工具

### 1. 单人转换工具：`pptx-to-md`

**路径**: `~/.local/bin/pptx-to-md`

**功能**: 转换单个 PPT 文件为 Markdown，带图片描述

**用法**:
```bash
pptx-to-md input.pptx [output.md]
```

**示例**:
```bash
pptx-to-md "年会总结.pptx"
pptx-to-md "年会总结.pptx" "output.md"
```

---

### 2. 批量转换工具：`pptx-batch-convert`

**路径**: `~/.local/bin/pptx-batch-convert`

**功能**: 批量转换目录中的所有 PPT 文件

**用法**:
```bash
pptx-batch-convert <input_dir> [output_dir]
```

**示例**:
```bash
# 转换当前目录所有PPT到默认Markdown文件夹
pptx-batch-convert ./PPTs

# 指定输出目录
pptx-batch-convert ./PPTs ./Output
```

---

## LLM 配置

本工具支持任何兼容 OpenAI API 格式的 Vision LLM。你需要设置以下环境变量：

### 必需环境变量

| 变量 | 说明 | 示例 |
|------|------|------|
| `LLM_API_URL` | LLM API 端点 | `https://api.openai.com/v1/chat/completions` |
| `LLM_MODEL` | 模型名称 | `gpt-4o` |

### 可选环境变量

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `LLM_API_KEY` | API 密钥 | 无 |
| `MAX_WORKERS` | 并发数 | `3` |
| `CACHE_DIR` | 缓存目录 | `/tmp/ppt_image_cache` |

### 配置方式

**方式 1: 使用 .env 文件（推荐）**

```bash
cp .env.example .env
# 编辑 .env 文件设置你的配置
```

**方式 2: 在 shell 配置文件中设置**

在 `~/.zshrc` 或 `~/.bashrc` 中添加：

```bash
# 添加到 PATH
export PATH="$HOME/.local/bin:$PATH"

# LLM 配置
export LLM_API_URL="your-api-url"
export LLM_API_KEY="your-api-key"
export LLM_MODEL="your-model-name"
```

### 各提供商配置示例

#### OpenAI

```bash
export LLM_API_URL="https://api.openai.com/v1/chat/completions"
export LLM_API_KEY="sk-your-openai-api-key"
export LLM_MODEL="gpt-4o"
```

#### Azure OpenAI

```bash
export LLM_API_URL="https://your-resource.openai.azure.com/openai/deployments/your-deployment/chat/completions?api-version=2024-02-15-preview"
export LLM_API_KEY="your-azure-api-key"
export LLM_MODEL="gpt-4o"
```

#### 本地模型 - vLLM

```bash
export LLM_API_URL="http://localhost:8000/v1/chat/completions"
export LLM_MODEL="Qwen/Qwen2-VL-7B-Instruct"
# LLM_API_KEY 不需要设置
```

#### 本地模型 - Ollama

```bash
export LLM_API_URL="http://localhost:11434/v1/chat/completions"
export LLM_MODEL="llava"
# LLM_API_KEY 不需要设置
```

#### Together AI

```bash
export LLM_API_URL="https://api.together.xyz/v1/chat/completions"
export LLM_API_KEY="your-together-api-key"
export LLM_MODEL="Qwen/Qwen2-VL-72B-Instruct"
```

---

## MCP 服务器配置

编辑 `~/.mcp.json`，替换占位符为你的实际配置：

```json
{
  "mcpServers": {
    "pptx-converter": {
      "command": "/opt/homebrew/bin/python3.11",
      "args": ["/Users/YOUR_USERNAME/.local/bin/pptx-converter-mcp"],
      "env": {
        "LLM_API_URL": "your-api-url",
        "LLM_API_KEY": "your-api-key",
        "LLM_MODEL": "your-model-name",
        "MAX_WORKERS": "3",
        "CACHE_DIR": "/tmp/ppt_image_cache"
      }
    }
  }
}
```

---

## 工具特性

### 核心功能
1. **自动提取图片** - 从 PPT 中提取所有图片
2. **AI 图片描述** - 使用 Vision LLM 生成描述
3. **多线程处理** - 默认 3 并发，提高效率
4. **智能缓存** - 避免重复处理相同图片
5. **Markdown 整合** - 将描述自动添加到对应图片下方

### 性能指标
- 单张图片处理时间: 取决于 LLM 提供商（本地 ~3-5 秒，云端 ~1-3 秒）
- 并发数: 可配置（默认 3）
- 支持格式: PNG, JPG, JPEG, GIF, BMP, WebP
- 缓存位置: 可配置（默认 `/tmp/ppt_image_cache/`）

---

## 使用示例

### 场景 1: 转换单个 PPT
```bash
pptx-to-md "report.pptx"
# 输出: report.md
```

### 场景 2: 批量转换
```bash
pptx-batch-convert "/path/to/ppt/folder"
# 输出到: /path/to/ppt/Markdown/
```

### 场景 3: 指定输出路径
```bash
pptx-to-md "input.pptx" "/custom/output/path/result.md"
```

---

## 故障排除

### 问题 1: "LLM_API_URL and LLM_MODEL must be set"
**原因**: 未配置必需的环境变量。
**解决**:
```bash
# 方式 1: 复制并编辑 .env 文件
cp .env.example .env
vim .env

# 方式 2: 直接设置环境变量
export LLM_API_URL="your-api-url"
export LLM_MODEL="your-model-name"
```

### 问题 2: 命令找不到
**解决**: 
```bash
export PATH="$HOME/.local/bin:$PATH"
```

### 问题 3: 权限拒绝
**解决**:
```bash
chmod +x ~/.local/bin/pptx-to-md
chmod +x ~/.local/bin/pptx-batch-convert
```

### 问题 4: 缺少依赖
**解决**:
```bash
python3.11 -m pip install requests markitdown
```

### 问题 5: API 连接失败
**检查**:
```bash
# 测试你的 API 端点是否可达
curl -s "$LLM_API_URL" -H "Authorization: Bearer $LLM_API_KEY"

# 对于本地模型，检查服务是否运行
curl -s http://localhost:8000/v1/models
```

### 问题 6: API 返回 401 Unauthorized
**原因**: API 密钥未设置或无效。
**解决**:
```bash
export LLM_API_KEY="your-valid-api-key"
```

---

## 输出格式

生成的 Markdown 文件结构：

```markdown
<!-- Slide number: 1 -->

![](图片1.jpg)

> **图片描述**: 这是一个蓝色的日历图标...

幻灯片文字内容...

<!-- Slide number: 2 -->
...
```

---

## 缓存管理

缓存文件位置：由 `CACHE_DIR` 环境变量控制（默认 `/tmp/ppt_image_cache/`）

- 每个 PPT 对应一个 JSON 缓存文件
- 图片缓存按 PPT 名称组织
- 可以手动删除缓存重新生成

---

## 更新日志

### v1.1 (2026-02-08)
- ✅ 支持多种 Vision LLM 后端
- ✅ 移除硬编码的 API 地址和模型名
- ✅ 添加 LLM_API_KEY 支持
- ✅ 环境变量验证和友好错误提示
- ✅ 添加 .env.example 配置模板
- ✅ 添加 llm-config.yaml.example 配置参考

### v1.0 (2024-02-07)
- ✅ 初始版本发布
- ✅ 支持单人/批量转换
- ✅ 多线程并发处理
- ✅ 智能缓存机制

---

## 依赖要求

- Python 3.11+
- requests
- markitdown
- 任意支持 OpenAI 兼容 API 的 Vision LLM

---

**配置完成！现在可以使用 `pptx-to-md` 和 `pptx-batch-convert` 命令了。**
