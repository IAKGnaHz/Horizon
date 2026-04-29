#!/bin/bash
# Horizon 每日新闻简报定时任务脚本

set -e

# 配置
PROJECT_DIR="$HOME/Documents/AMH/ALL-AI/Horizon"
LOG_DIR="$PROJECT_DIR/logs"
LOG_FILE="$LOG_DIR/horizon-$(date +%Y%m%d).log"

# 确保日志目录存在
mkdir -p "$LOG_DIR"

# 进入项目目录
cd "$PROJECT_DIR"

# 运行 Horizon（抓取过去 24 小时）
echo "[$(date)] 开始运行 Horizon..." >> "$LOG_FILE"
UV_INDEX_URL=https://pypi.tuna.tsinghua.edu.cn/simple uv run horizon --hours 24 >> "$LOG_FILE" 2>&1
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    echo "[$(date)] Horizon 运行成功" >> "$LOG_FILE"

    # 可选：清理 7 天前的日志
    find "$LOG_DIR" -name "horizon-*.log" -mtime +7 -delete 2>/dev/null || true

    # 可选：发送通知（飞书/钉钉等）
    # curl -X POST "$WEBHOOK_URL" -H "Content-Type: application/json" -d '{"msg_type":"text","content":{"text":"Horizon 日报已生成"}}'
else
    echo "[$(date)] Horizon 运行失败，退出码: $EXIT_CODE" >> "$LOG_FILE"
fi

exit $EXIT_CODE
