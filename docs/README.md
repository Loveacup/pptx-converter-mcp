# MCP 配置指南 - PPT 转 Markdown 工具

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

## 环境变量配置

在 `~/.zshrc` 或 `~/.bashrc` 中添加：

```bash
# 添加到 PATH
export PATH="$HOME/.local/bin:$PATH"

# LLM 配置（使用本地 Qwen3-VL-32B）
export LLM_API_URL="http://172.16.27.10:9998/v1/chat/completions"
export LLM_MODEL="Qwen3-VL-32B"
export MAX_WORKERS="3"
export CACHE_DIR="/tmp/ppt_image_cache"
```

---

## MCP 服务器配置

已创建 `~/.mcp.json`：

```json
{
  "mcpServers": {
    "markitdown": {
      "command": "/opt/homebrew/bin/python3.11",
      "args": ["-m", "markitdown_mcp"],
      "env": {
        "OPENAI_API_KEY": "dummy",
        "OPENAI_BASE_URL": "http://172.16.27.10:9998/v1",
        "OPENAI_MODEL": "Qwen3-VL-32B"
      }
    }
  }
}
```

**注意**: markitdown-mcp 默认不支持图片描述，推荐使用上面的自定义工具。

---

## 工具特性

### ✅ 核心功能
1. **自动提取图片** - 从 PPT 中提取所有图片
2. **AI 图片描述** - 使用本地 Qwen3-VL-32B 模型生成描述
3. **多线程处理** - 默认 3 并发，提高效率
4. **智能缓存** - 避免重复处理相同图片
5. **Markdown 整合** - 将描述自动添加到对应图片下方

### 📊 性能指标
- 单张图片处理时间: ~3-5 秒
- 并发数: 3（可调节）
- 支持格式: PNG, JPG, JPEG, GIF, BMP, WebP
- 缓存位置: `/tmp/ppt_image_cache/`

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

### 问题 1: 命令找不到
**解决**: 
```bash
export PATH="$HOME/.local/bin:$PATH"
```

### 问题 2: 权限拒绝
**解决**:
```bash
chmod +x ~/.local/bin/pptx-to-md
chmod +x ~/.local/bin/pptx-batch-convert
```

### 问题 3: 缺少依赖
**解决**:
```bash
/opt/homebrew/bin/python3.11 -m pip install requests markitdown
```

### 问题 4: API 连接失败
**检查**:
```bash
curl http://172.16.27.10:9998/v1/models
```

---

## 输出格式

生成的 Markdown 文件结构：

```markdown
<!-- Slide number: 1 -->

![](图片1.jpg)

> 🖼️ **图片描述**: 这是一个蓝色的日历图标...

幻灯片文字内容...

<!-- Slide number: 2 -->
...
```

---

## 缓存管理

缓存文件位置：`/tmp/ppt_image_cache/`

- 每个 PPT 对应一个 JSON 缓存文件
- 图片缓存按 PPT 名称组织
- 可以手动删除缓存重新生成

---

## 更新日志

### v1.0 (2024-02-07)
- ✅ 初始版本发布
- ✅ 支持单人/批量转换
- ✅ 集成 Qwen3-VL-32B 图片识别
- ✅ 多线程并发处理
- ✅ 智能缓存机制
- ✅ 修复图片描述整合问题

---

## 依赖要求

- Python 3.11+
- requests
- markitdown
- 本地 LLM API (Qwen3-VL-32B)

---

**配置完成！现在可以使用 `pptx-to-md` 和 `pptx-batch-convert` 命令了。**
