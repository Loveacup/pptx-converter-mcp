# PPTX Converter MCP — 开发方法论

本文档面向 AI 编程助手和开发者，说明 PPTX Converter MCP 的设计思路、架构决策和扩展方式。

## 1. 设计目标

**核心问题**：AI 编程助手无法直接读取 PowerPoint 文件。PPT 是企业常用格式，包含文本、布局、图表和嵌入图片，需要将其转为 AI 友好的 Markdown 格式。

**解决方案**：两阶段转换管线 — 先用 MarkItDown 提取文本和布局，再用 Vision LLM 描述每张嵌入图片，最终合并为完整的 Markdown 文档。

**设计原则**：
- **双模式运行**：CLI 工具（直接命令行使用）+ MCP 服务器（AI agent 调用）
- **图片不丢失**：PPT 中的图片通过 AI 生成描述文本，而非简单丢弃
- **幂等缓存**：相同图片不重复调用 LLM API，节省时间和费用

## 2. 架构

```
┌──────────┐     ┌──────────────┐     ┌────────────┐     ┌──────────┐
│  .pptx   │────>│  MarkItDown  │────>│ Vision LLM │────>│ Markdown │
│  文件     │     │  文本+布局   │     │  图片描述   │     │  输出     │
└──────────┘     └──────────────┘     └────────────┘     └──────────┘
```

### 组件分工

| 组件 | 文件 | 职责 |
|---|---|---|
| **CLI 单文件** | `bin/pptx-to-md` | 单个 PPT → Markdown 转换 |
| **CLI 批量** | `bin/pptx-batch-convert` | 目录下所有 PPT 批量转换 |
| **MCP 服务器** | `bin/pptx-converter-mcp` | 暴露 `convert_single_pptx` 和 `convert_batch_pptx` 工具 |
| **安装器** | `install.sh` | 创建 venv、安装依赖、配置 PATH、注册 MCP |

### MCP 服务器的委托模式

MCP 服务器本身**不包含转换逻辑**，而是通过 `subprocess.run()` 调用 CLI 工具。这是有意为之的架构决策：

```python
def run_pptx_to_md(input_path, output_path=None):
    cmd = [str(TOOLS_DIR / "pptx-to-md"), input_path]
    result = subprocess.run(cmd, capture_output=True, text=True, timeout=600)
    return {"success": result.returncode == 0, ...}
```

**为什么用 subprocess 而不是直接调用？**
- CLI 工具已经处理了完整的转换流程（解析、图片提取、LLM 调用、合并）
- 进程隔离：转换失败不会影响 MCP 服务器
- 单一职责：MCP 层只负责协议适配

## 3. 转换管线详解

### 阶段一：文本提取（MarkItDown）

[Microsoft MarkItDown](https://github.com/microsoft/markitdown) 处理 PPTX 文件的 XML 结构，提取：
- 幻灯片文本内容
- 标题和副标题层级
- 列表和表格
- 布局信息

输出初始 Markdown，其中图片位置用占位符标记。

### 阶段二：图片描述（Vision LLM）

对每张嵌入图片：
1. 从 PPTX 压缩包中提取图片文件
2. 转为 base64 编码
3. 发送到 Vision LLM API，使用专门的提示词获取描述
4. 将描述文本替换回 Markdown 中的图片占位符

### 阶段三：合并输出

将文本和图片描述合并为最终 Markdown 文件。

## 4. 多线程图片处理

PPT 中通常有多张图片，逐个调用 LLM 很慢。通过 `MAX_WORKERS` 环境变量控制并发线程数（默认 3），并行处理图片描述：

- 3 个 worker：适合大多数 API 端点
- 增加到 5–8：本地部署的模型可以更高
- 设为 1：调试时强制串行

## 5. 智能缓存机制

图片基于内容 hash 缓存到 `CACHE_DIR`（默认 `/tmp/ppt_image_cache`）：

- 相同图片（即使来自不同 PPT）只调用一次 LLM
- 重新转换同一个 PPT 时直接命中缓存
- 缓存文件为纯文本，内容是 LLM 返回的图片描述

## 6. LLM 后端适配

所有 LLM 调用都通过 OpenAI 兼容的 chat completions API：

```
POST {LLM_API_URL}
{
  "model": "{LLM_MODEL}",
  "messages": [
    {"role": "user", "content": [
      {"type": "text", "text": "描述这张图片..."},
      {"type": "image_url", "image_url": {"url": "data:image/png;base64,..."}}
    ]}
  ]
}
```

适用于：OpenAI、Azure OpenAI、vLLM、Ollama 以及任何 OpenAI 兼容端点。

## 7. 安装器设计

`install.sh` 的目标是**一键可用**：

1. 检测 Python 3.11+ 和 pip
2. 创建 `~/.local/share/pptx-converter/venv` 虚拟环境
3. 安装 `markitdown`、`mcp` 等 Python 依赖
4. 将 `bin/` 下的三个入口脚本链接到 `~/.local/bin/`
5. 在 `~/.mcp.json` 中注册 MCP 服务器（如果用户确认）
6. 提示用户将 `~/.local/bin` 加入 PATH

## 8. 添加新功能

### 支持新文件格式

MarkItDown 本身支持 DOCX、XLSX 等格式，扩展转换器只需：
1. 在 CLI 工具中添加格式检测逻辑
2. 在 MCP 服务器中注册新工具
3. 更新安装器和文档

### 自定义图片提示词

编辑 CLI 工具中的 prompt 模板，可以针对不同类型的图片（图表、截图、照片）使用不同的分析提示词。

## 9. 局限性

- **图片描述质量依赖 LLM**：便宜/小的模型可能输出粗略描述
- **复杂布局丢失**：MarkItDown 主要提取文本，复杂的排版和动画效果无法完美还原
- **大文件耗时**：包含大量高分辨率图片的 PPT 转换可能需要数分钟
- **仅支持 .pptx**：不支持旧版 .ppt（Office 2003 及更早）格式
