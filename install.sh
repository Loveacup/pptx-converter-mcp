#!/bin/bash
# PPTX Converter MCP 安装脚本
# 用法: ./install.sh

set -e

echo "================================"
echo "PPTX Converter MCP 安装程序"
echo "================================"
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查 Python 3.11
echo "🔍 检查 Python 3.11..."
if command -v /opt/homebrew/bin/python3.11 &> /dev/null; then
    PYTHON="/opt/homebrew/bin/python3.11"
    echo -e "${GREEN}✅ 找到 Python 3.11${NC}"
elif command -v python3.11 &> /dev/null; then
    PYTHON="python3.11"
    echo -e "${GREEN}✅ 找到 Python 3.11${NC}"
else
    echo -e "${RED}❌ 未找到 Python 3.11${NC}"
    echo "请安装 Python 3.11: brew install python@3.11"
    exit 1
fi

# 检查并安装依赖
echo ""
echo "📦 检查依赖..."

$PYTHON -c "import requests" 2>/dev/null || {
    echo "安装 requests..."
    $PYTHON -m pip install requests -q
}

$PYTHON -c "from mcp.server import Server" 2>/dev/null || {
    echo "安装 mcp..."
    $PYTHON -m pip install mcp -q
}

$PYTHON -c "import markitdown" 2>/dev/null || {
    echo "安装 markitdown..."
    $PYTHON -m pip install markitdown -q
}

echo -e "${GREEN}✅ 依赖检查完成${NC}"

# 创建安装目录
echo ""
echo "📁 创建安装目录..."
INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"

# 复制工具
echo ""
echo "🛠️  安装工具..."
cp bin/pptx-to-md "$INSTALL_DIR/"
cp bin/pptx-batch-convert "$INSTALL_DIR/"
cp bin/pptx-converter-mcp "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR"/pptx-*

echo -e "${GREEN}✅ 工具安装完成${NC}"

# 添加到 PATH
echo ""
echo "🔧 配置环境变量..."
SHELL_CONFIG=""
if [ -f "$HOME/.zshrc" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
elif [ -f "$HOME/.bash_profile" ]; then
    SHELL_CONFIG="$HOME/.bash_profile"
fi

if [ -n "$SHELL_CONFIG" ]; then
    if ! grep -q "$HOME/.local/bin" "$SHELL_CONFIG"; then
        echo "" >> "$SHELL_CONFIG"
        echo "# PPTX Converter MCP" >> "$SHELL_CONFIG"
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_CONFIG"
        echo -e "${GREEN}✅ 已添加到 PATH ($SHELL_CONFIG)${NC}"
    else
        echo -e "${YELLOW}⚠️  PATH 已配置${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  未找到 shell 配置文件，请手动添加:${NC}"
    echo 'export PATH="$HOME/.local/bin:$PATH"'
fi

# 安装 MCP 配置
echo ""
echo "⚙️  安装 MCP 配置..."
if [ -f "$HOME/.mcp.json" ]; then
    echo -e "${YELLOW}⚠️  已存在 .mcp.json，备份到 .mcp.json.backup${NC}"
    cp "$HOME/.mcp.json" "$HOME/.mcp.json.backup"
fi

cp config/mcp.json.template "$HOME/.mcp.json"
echo -e "${GREEN}✅ MCP 配置已安装${NC}"

# 创建缓存目录
mkdir -p /tmp/ppt_image_cache

# 复制 .env.example 如果不存在
if [ ! -f "$(pwd)/.env" ]; then
    echo ""
    echo "📝 配置 LLM..."
    echo -e "${YELLOW}⚠️  请配置 LLM 环境变量${NC}"
    echo "   复制 .env.example 到 .env 并填写你的配置:"
    echo "   cp .env.example .env"
    echo "   vim .env"
fi

echo ""
echo "================================"
echo -e "${GREEN}🎉 安装完成！${NC}"
echo "================================"
echo ""
echo "使用方式:"
echo "  1. 重新加载 shell 配置:"
echo "     source $SHELL_CONFIG"
echo ""
echo "  2. 单人转换:"
echo "     pptx-to-md input.pptx output.md"
echo ""
echo "  3. 批量转换:"
echo "     pptx-batch-convert /path/to/ppt/folder"
echo ""
echo "  4. 在 Claude Code 中使用:"
echo "     请帮我将 file.pptx 转换为 Markdown"
echo ""
echo "文档: $(pwd)/docs/README.md"
echo ""
