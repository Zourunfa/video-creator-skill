#!/bin/bash
# ============================================================
# AI Harness Engineering 视频多平台发布脚本
# 平台: 抖音 / B站 / 小红书 / 快手
# 工具: social-auto-upload (sau CLI)
# ============================================================

set -e

# ==================== 配置区 ====================

# 视频文件路径
VIDEO_FILE="/Users/a1804491927/Code/open-source/video-factory/out/ai_harness_final.mp4"

# 账号名（改成你自己的 account_name）
ACCOUNT="creator"

# --- 抖音 ---
DOUYIN_TITLE="AI Harness Engineering 全栈开发者的AI工程化指南"
DOUYIN_DESC="什么是AI Harness？Prompt工程化、RAG管道、评估体系、安全护栏四大支柱详解。全栈项目中如何落地实践？工具链推荐：Vercel AI SDK、LangSmith、Promptfoo"
DOUYIN_TAGS="AI工程化,全栈开发,Prompt工程,RAG,教程"

# --- B站 ---
BILI_TITLE="AI Harness Engineering 科普与教学 全栈开发者必看"
BILI_DESC="AI Harness Engineering 是一套系统化的方法论，用来构建、监控和迭代AI驱动的应用。本视频涵盖四大核心支柱：Prompt工程化、RAG检索增强生成、评估体系、安全护栏，以及在全栈项目中的落地实践。工具链推荐：Vercel AI SDK、LangSmith、Promptfoo等。"
BILI_TAGS="AI工程化,全栈开发,Prompt工程,RAG,技术教程"
BILI_TID=122  # 野生技术协会

# --- 小红书 ---
XHS_TITLE="AI Harness Engineering 全栈开发者指南"
XHS_DESC="AI工程化四大支柱详解：Prompt管理、RAG管道、评估流水线、安全护栏。附工具链推荐，全栈项目落地必看！"
XHS_TAGS="AI工程化,全栈开发,技术教程,Prompt"

# --- 快手 ---
KS_TITLE="AI Harness Engineering 全栈开发者AI工程化指南"
KS_DESC="什么是AI Harness？四大核心支柱详解，全栈项目落地实践，工具链推荐"
KS_TAGS="AI工程化,全栈开发,技术教程"

# social-auto-upload 项目路径
SAU_DIR="/Users/a1804491927/Code/open-source/social-auto-upload"

# ==================== 函数定义 ====================

cd "$SAU_DIR"

publish_douyin() {
  echo "=========================================="
  echo "  发布到抖音..."
  echo "=========================================="
  python sau_cli.py douyin upload-video \
    --account "$ACCOUNT" \
    --file "$VIDEO_FILE" \
    --title "$DOUYIN_TITLE" \
    --desc "$DOUYIN_DESC" \
    --tags "$DOUYIN_TAGS" \
    --headed
  echo "✅ 抖音发布完成"
}

publish_bilibili() {
  echo "=========================================="
  echo "  发布到B站..."
  echo "=========================================="
  python sau_cli.py bilibili upload-video \
    --account "$ACCOUNT" \
    --file "$VIDEO_FILE" \
    --title "$BILI_TITLE" \
    --desc "$BILI_DESC" \
    --tid "$BILI_TID" \
    --tags "$BILI_TAGS"
  echo "✅ B站发布完成"
}

publish_xiaohongshu() {
  echo "=========================================="
  echo "  发布到小红书..."
  echo "=========================================="
  python sau_cli.py xiaohongshu upload-video \
    --account "$ACCOUNT" \
    --file "$VIDEO_FILE" \
    --title "$XHS_TITLE" \
    --desc "$XHS_DESC" \
    --tags "$XHS_TAGS" \
    --headed
  echo "✅ 小红书发布完成"
}

publish_kuaishou() {
  echo "=========================================="
  echo "  发布到快手..."
  echo "=========================================="
  python sau_cli.py kuaishou upload-video \
    --account "$ACCOUNT" \
    --file "$VIDEO_FILE" \
    --title "$KS_TITLE" \
    --desc "$KS_DESC" \
    --tags "$KS_TAGS" \
    --headed
  echo "✅ 快手发布完成"
}

# ==================== 主流程 ====================

echo ""
echo "🎬 AI Harness Engineering — 多平台发布"
echo "   视频: $VIDEO_FILE"
echo "   账号: $ACCOUNT"
echo ""

if [ "$1" = "douyin" ]; then
  publish_douyin
elif [ "$1" = "bilibili" ]; then
  publish_bilibili
elif [ "$1" = "xiaohongshu" ]; then
  publish_xiaohongshu
elif [ "$1" = "kuaishou" ]; then
  publish_kuaishou
elif [ "$1" = "all" ]; then
  publish_douyin
  echo ""
  publish_bilibili
  echo ""
  publish_xiaohongshu
  echo ""
  publish_kuaishou
  echo ""
  echo "🎉 全部平台发布完成！"
else
  echo "用法:"
  echo "  bash publish.sh douyin       # 仅发布到抖音"
  echo "  bash publish.sh bilibili     # 仅发布到B站"
  echo "  bash publish.sh xiaohongshu  # 仅发布到小红书"
  echo "  bash publish.sh kuaishou     # 仅发布到快手"
  echo "  bash publish.sh all          # 发布到全部平台"
  echo ""
  echo "提示: 发布前请先登录各平台账号："
  echo "  python sau_cli.py douyin login --account $ACCOUNT"
  echo "  python sau_cli.py bilibili login --account $ACCOUNT"
  echo "  python sau_cli.py xiaohongshu login --account $ACCOUNT"
  echo "  python sau_cli.py kuaishou login --account $ACCOUNT"
fi
