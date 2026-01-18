#!/bin/bash
# Rust Skills 设置脚本

# 确定插件目录路径
CUSTOM_PATH="D:\soft-dev\code\rust\rust-skills"
if [ -d "$CUSTOM_PATH" ]; then
    PLUGIN_DIR="$CUSTOM_PATH"
else
    PLUGIN_DIR="$(dirname "$0")"
fi

echo "正在为 Claude Code 设置 Rust Skills..."

# 如果权限文件不存在则创建
if [ ! -f ".claude/settings.local.json" ]; then
    mkdir -p .claude
    cat > .claude/settings.local.json << 'EOF'
{
  "permissions": {
    "allow": [
      "Bash(agent-browser *)"
    ]
  }
}
EOF
    echo "已创建 .claude/settings.local.json 并添加 agent-browser 权限"
else
    echo ".claude/settings.local.json 已存在，请手动添加权限："
    echo '  "Bash(agent-browser *)"'
fi

echo "设置完成！"
echo ""
echo "使用方法："
echo "  claude --plugin-dir $PLUGIN_DIR"
