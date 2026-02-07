# 🚀 PPTX Converter MCP - 快速参考

## 安装

```bash
./install.sh
source ~/.zshrc  # 或 ~/.bashrc
```

## 使用

### 命令行

```bash
# 单人转换
pptx-to-md "file.pptx" "output.md"

# 批量转换
pptx-batch-convert "/path/to/ppt/folder"
```

### Claude Code

```
请帮我将 file.pptx 转换为 Markdown

或

请批量转换 /path/to/ppt/folder 中的所有 PPT
```

## 配置

设置环境变量（必需）:
```bash
export LLM_API_URL="your-api-url"
export LLM_MODEL="your-model-name"
export LLM_API_KEY="your-api-key"  # 如需要
```

详见 `.env.example` 配置示例。

## 文件位置

- 工具: `~/.local/bin/`
- 配置: `~/.mcp.json`
- 缓存: `/tmp/ppt_image_cache/`

## 功能

- ✅ 单人/批量 PPT 转换
- ✅ AI 图片描述（本地模型）
- ✅ 多线程并发
- ✅ 智能缓存
- ✅ MCP 服务器支持

## 文档

- 完整文档: `docs/README.md`
- 部署指南: `docs/MCP-DEPLOYMENT.md`

## 测试

```bash
./test_mcp_server.py
```

---

**版本:** 1.0 | **日期:** 2024-02-08
