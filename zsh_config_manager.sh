#!/bin/bash

# Safe Zshrc Configuration Manager
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

BACKUP_DIR="$HOME/.zsh_backups"
ZSHRC_PATH="$HOME/.zshrc"

# Create backup directory
mkdir -p "$BACKUP_DIR"

show_menu() {
    echo -e "${BLUE}╔══════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║   Safe Zshrc Configuration Manager   ║ ${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════╝${NC}"
    echo ""
    echo "1) Modify .zshrc (auto backup) / 修改.zshrc（自动备份）"
    echo "2) Clean all backup files / 清理所有备份文件"
    echo "3) Exit / 退出"
    echo ""
}

backup_zshrc() {
    if [[ -f "$ZSHRC_PATH" ]]; then
        local timestamp=$(date +"%Y%m%d_%H%M%S")
        local backup_file="$BACKUP_DIR/.zshrc.backup.$timestamp"
        cp "$ZSHRC_PATH" "$backup_file"
        echo -e "${GREEN}Backup created: $backup_file${NC}"
        echo -e "${GREEN}已创建备份：$backup_file${NC}"
        return 0
    else
        echo -e "${RED}Error: .zshrc not found / 未找到.zshrc文件${NC}"
        return 1
    fi
}

clean_backups() {
    local backup_count=$(ls -1 "$BACKUP_DIR"/.zshrc.backup.* 2>/dev/null | wc -l)
    
    if [[ $backup_count -eq 0 ]]; then
        echo -e "${GREEN}No backup files found / 没有备份文件${NC}"
        return
    fi
    
    echo -e "${BLUE}Found $backup_count backup files / 发现 $backup_count 个备份文件${NC}"
    ls -lah "$BACKUP_DIR"/.zshrc.backup.*
    
    read -rp "Delete these backups? (y/N) / 确定删除这些备份吗？(y/N): " confirm
    if [[ $confirm == [yY] ]]; then
        rm -f "$BACKUP_DIR"/.zshrc.backup.*
        echo -e "${GREEN}All backups deleted / 已清理所有备份${NC}"
    else
        echo -e "${BLUE}Operation canceled / 已取消${NC}"
    fi
}

modify_zshrc() {
    echo -e "${GREEN}Preparing to modify .zshrc... / 准备修改.zshrc...${NC}"
    
    if backup_zshrc; then
        echo ""
        echo -e "${YELLOW}Vim Tutorial / vim教程：${NC}"
        echo "  • Press i to insert mode / 按 i 进入插入模式"
        echo "  • Press Esc to normal mode / 按 Esc 返回普通模式"
        echo "  • Type :wq to save and exit / 输入 :wq 保存退出"
        echo "  • Type :q! to exit without saving / 输入 :q! 不保存退出"
        echo ""
        
        read -rp "Press Enter to start editing / 按回车键开始编辑... "
        vim "$ZSHRC_PATH"
        
        echo -e "${GREEN}Edit complete! Run 'source ~/.zshrc' to apply changes / 编辑完成！运行 source ~/.zshrc 生效${NC}"
    fi
}

# Main program
while true; do
    clear
    show_menu
    read -rp "Select [1-3] / 请选择 [1-3]: " choice
    
    case $choice in
        1) modify_zshrc; read -rp "Press Enter to continue / 按回车继续..." ;;
        2) clean_backups; read -rp "Press Enter to continue / 按回车继续..." ;;
        3) echo "Goodbye / 再见!"; exit 0 ;;
        *) echo "Invalid choice / 无效选择."; read -rp "Press Enter to continue / 按回车继续..." ;;
    esac
done
