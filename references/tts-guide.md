# edge-tts 使用指南

## 安装

```bash
pip install edge-tts
```

## 基本用法

```bash
edge-tts --voice zh-CN-YunxiNeural --text "你好，这是一段测试语音" --write-media output.mp3
```

## 中文语音列表

### 推荐语音

| 语音名称 | 性别 | 风格 | 适用场景 |
|----------|------|------|----------|
| `zh-CN-YunxiNeural` | 男 | 年轻、阳光 | **默认推荐**，技术讲解、教程 |
| `zh-CN-YunjianNeural` | 男 | 成稳、专业 | 新闻播报、严肃分析 |
| `zh-CN-XiaoxiaoNeural` | 女 | 温柔、自然 | 轻松话题、教学 |
| `zh-CN-XiaoyiNeural` | 女 | 活泼、年轻 | 轻松活泼内容 |
| `zh-CN-YunyangNeural` | 男 | 新闻主播 | 正式播报 |

### 列出所有可用语音

```bash
edge-tts --list-voices | grep zh-CN
```

## 语速调整

### 通过 --rate 参数

```bash
# 正常语速
edge-tts --voice zh-CN-YunxiNeural --rate=+0% --text "正常语速" --write-media normal.mp3

# 加快 10%
edge-tts --voice zh-CN-YunxiNeural --rate=+10% --text "稍快语速" --write-media fast.mp3

# 加快 20%
edge-tts --voice zh-CN-YunxiNeural --rate=+20% --text "很快语速" --write-media faster.mp3

# 减慢 10%
edge-tts --voice zh-CN-YunxiNeural --rate=-10% --text "稍慢语速" --write-media slow.mp3
```

### 语速选择建议

| 语速 | rate 值 | 字/秒 | 适用场景 |
|------|---------|-------|----------|
| 慢速 | -10% | ~2.5 | 复杂概念讲解 |
| 正常 | +0% | ~3.5 | 通用场景 |
| 偏快 | +10% | ~4.0 | 熟悉受众、信息密度高 |
| 快速 | +20% | ~4.5 | 快节奏、简短内容 |

## 批量生成脚本

### Shell 脚本模板

```bash
#!/bin/bash
# generate_tts.sh — 批量生成 TTS 音频

VOICE="zh-CN-YunxiNeural"
RATE="+0%"
OUTPUT_DIR="public/audio"

mkdir -p "$OUTPUT_DIR"

# 定义场景文本（数组）
declare -a SCENES=(
  "大家好，今天我们来聊聊一个热门话题。"
  "首先，让我们回顾一下事件的背景。"
  "接下来，我们深入分析核心技术原理。"
  "最后，总结一下关键要点。"
  "感谢观看，我们下期再见！"
)

# 批量生成
for i in "${!SCENES[@]}"; do
  NUM=$((i + 1))
  echo "正在生成第 ${NUM} 段音频..."
  edge-tts --voice "$VOICE" --rate="$RATE" \
    --text "${SCENES[$i]}" \
    --write-media "${OUTPUT_DIR}/scene_${NUM}.mp3"
  echo "  → ${OUTPUT_DIR}/scene_${NUM}.mp3 完成"
done

echo "全部音频生成完毕！"
```

### Python 脚本模板（更灵活）

```python
#!/usr/bin/env python3
"""generate_tts.py — 批量生成 TTS 音频"""

import asyncio
import edge_tts
import os

VOICE = "zh-CN-YunxiNeural"
RATE = "+0%"
OUTPUT_DIR = "public/audio"

SCENES = [
    ("opening", "大家好，今天我们来聊聊一个热门话题。"),
    ("background", "首先，让我们回顾一下事件的背景。"),
    ("analysis", "接下来，我们深入分析核心技术原理。"),
    ("summary", "最后，总结一下关键要点。"),
    ("closing", "感谢观看，我们下期再见！"),
]

async def generate(scene_name: str, text: str):
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    output_path = os.path.join(OUTPUT_DIR, f"{scene_name}.mp3")
    communicate = edge_tts.Communicate(text, VOICE, rate=RATE)
    await communicate.save(output_path)
    print(f"  → {output_path}")

async def main():
    print(f"开始生成 {len(SCENES)} 段音频...")
    for name, text in SCENES:
        print(f"生成: {name}")
        await generate(name, text)
    print("全部完成！")

if __name__ == "__main__":
    asyncio.run(main())
```

## 音频时长检测

### 单个文件

```bash
ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 public/audio/scene_1.mp3
```

### 批量检测并汇总

```bash
echo "音频时长汇总："
total=0
for f in public/audio/*.mp3; do
  dur=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$f")
  name=$(basename "$f")
  printf "  %-20s %6.2f 秒\n" "$name" "$dur"
  total=$(echo "$total + $dur" | bc)
done
printf "  %-20s %6.2f 秒\n" "总计" "$total"
printf "  预计帧数（@30fps）：%d\n" $(echo "$total * 30" | bc | cut -d. -f1)
```

## 常见问题

### 连接超时

edge-tts 依赖微软在线服务，网络不稳定时会超时。

```bash
# 解决方案：重试
for i in 1 2 3; do
  edge-tts --voice zh-CN-YunxiNeural --text "测试" --write-media test.mp3 && break
  echo "第 ${i} 次重试..."
  sleep 2
done
```

### 音频质量

edge-tts 输出为 MP3 格式，采样率 24kHz。对于视频配音来说质量足够。

### 长文本处理

单次调用建议不超过 500 字。长脚本应拆分为多个场景分别生成，便于：
- 重新生成单个场景不影响其他
- 精确控制每个场景时长
- 后续调整更灵活
