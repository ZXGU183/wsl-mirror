# 安装 jq 工具处理 JSON
sudo apt update && sudo apt install -y jq

# 创建更新脚本
sudo tee /usr/local/bin/update_github_hosts <<'EOF'
#!/bin/bash
set -e

# 清除旧的 GitHub hosts 记录（保留原有匹配模式）
sudo sed -i '/# GitHub Hosts Start/,/# GitHub Hosts End/d' /etc/hosts

# 添加新内容时避免多余空行
{
    echo "# GitHub Hosts Start"
    echo "# Updated: $(date)"
    curl -sSL https://raw.hellogithub.com/hosts.json | \
        jq -r '.hosts[] | "\(.ip) \(.domain)"'
    echo "# GitHub Hosts End"
} | sudo tee -a /etc/hosts > /dev/null

# 刷新 DNS 缓存
if command -v systemd-resolve &> /dev/null; then
    sudo systemd-resolve --flush-caches
fi
EOF

# 设置权限
sudo chmod +x /usr/local/bin/update_github_hosts

# 添加自动任务和日志记录
COMMAND_TO_RUN="/usr/local/bin/update_github_hosts"
CRON_JOB="0 * * * * for i in {1..3}; do ${COMMAND_TO_RUN} && break || sleep 30; done >> /var/log/github-hosts.log 2>&1"

# 移除旧的定时任务（如果存在），然后添加新的，以防止重复
(sudo crontab -l 2>/dev/null | grep -v -F "${COMMAND_TO_RUN}"; echo "${CRON_JOB}") | sudo crontab -

# 重启计划任务
if command -v systemctl &> /dev/null && systemctl is-active --quiet cron; then
    sudo systemctl restart cron
else
    sudo service cron restart
fi