#!/bin/bash
# OpenClaw Skills 自动同步脚本
# 自动提交并推送到 GitHub

SKILLS_DIR="/Users/susu/Tools/jb/AI/skills"
cd "$SKILLS_DIR"

# 重命名包含空格的文件/目录（空格替换为下划线）
find . -depth -name "* *" -not -path "./.git/*" | while read -r file; do
    new_name=$(echo "$file" | tr ' ' '_')
    if [ "$file" != "$new_name" ]; then
        git mv "$file" "$new_name" 2>/dev/null || mv "$file" "$new_name"
        echo "Renamed: $file -> $new_name"
    fi
done

# 检查是否有更改
if git diff --quiet && git diff --staged --quiet; then
    echo "No changes to sync."
    exit 0
fi

# 获取当前时间
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# 添加所有更改
git add -A

# 提交
git commit -m "Auto-sync: $TIMESTAMP"

# 推送
git push origin main

echo "✅ Synced to GitHub at $TIMESTAMP"
