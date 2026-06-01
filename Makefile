.PHONY: install install-ci validate setup help

# 默认安装到当前目录
TARGET ?= .

help:
	@echo "Vibe Coding Playbook — 一键命令"
	@echo ""
	@echo "  make install          安装到 TARGET（默认当前目录）"
	@echo "  make install-ci       安装并包含 GitHub Actions"
	@echo "  make setup            安装到当前目录 + CI + 推送"
	@echo "  make validate         运行本地验证"
	@echo ""
	@echo "  示例: make install TARGET=~/Projects/my-app"

install:
	@./install.sh "$(TARGET)"

install-ci:
	@./install.sh "$(TARGET)" --with-ci

setup:
	@./install.sh "$(TARGET)" --with-ci --push

validate:
	@./scripts/validate.sh
