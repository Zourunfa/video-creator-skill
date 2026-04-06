# 多平台发布指南

## social-auto-upload 概述

social-auto-upload 是一个开源工具，支持自动化上传视频到多个平台。

GitHub: https://github.com/dreammis/social-auto-upload

## 安装与配置

```bash
git clone https://github.com/dreammis/social-auto-upload.git
cd social-auto-upload
pip install -r requirements.txt
```

### 账号登录

发布前需先登录各平台：

```bash
cd {tools_social_upload}
python sau_cli.py douyin login --account creator
python sau_cli.py bilibili login --account creator
python sau_cli.py xiaohongshu login --account creator
python sau_cli.py kuaishou login --account creator
```

> Cookie 过期后需要重新登录。如果上传失败，首先检查登录状态。

## sau_cli.py 命令格式

### 抖音发布

```bash
cd {tools_social_upload}
python sau_cli.py douyin upload-video \
  --account creator \
  --file "{output_dir}/final_video.mp4" \
  --title "视频标题" \
  --desc "视频描述" \
  --tags "标签1,标签2,标签3" \
  --headed
```

### B站发布

```bash
cd {tools_social_upload}
python sau_cli.py bilibili upload-video \
  --account creator \
  --file "{output_dir}/final_video.mp4" \
  --title "视频标题" \
  --desc "视频描述" \
  --tid 122 \
  --tags "标签1,标签2,标签3"
```

### 小红书发布

```bash
cd {tools_social_upload}
python sau_cli.py xiaohongshu upload-video \
  --account creator \
  --file "{output_dir}/final_video.mp4" \
  --title "视频标题" \
  --desc "视频描述" \
  --tags "标签1,标签2,标签3" \
  --headed
```

### 快手发布

```bash
cd {tools_social_upload}
python sau_cli.py kuaishou upload-video \
  --account creator \
  --file "{output_dir}/final_video.mp4" \
  --title "视频标题" \
  --desc "视频描述" \
  --tags "标签1,标签2,标签3" \
  --headed
```

> **注意**：实际 CLI 参数格式可能因 social-auto-upload 版本而异。使用前先检查项目的 README.md 确认最新用法。`--headed` 参数用于有头浏览器模式（部分平台需要）。

## 各平台限制

| 平台 | 标题长度 | 描述长度 | 标签数 | 视频大小 | 格式 |
|------|----------|----------|--------|----------|------|
| B站 | ≤ 80 字 | ≤ 250 字 | ≤ 12 个 | ≤ 8 GB | MP4 |
| 抖音 | ≤ 55 字 | 无 | 通过标题带# | ≤ 4 GB | MP4 |
| 小红书 | ≤ 20 字 | ≤ 1000 字 | 通过正文带# | ≤ 5 GB | MP4 |
| 快手 | ≤ 55 字 | 无 | 通过标题带# | ≤ 4 GB | MP4 |

## B站分区 (tid) 常用值

| tid | 分区名称 | 适用场景 |
|-----|----------|----------|
| 122 | 野生技术协会 | **默认推荐**，通用技术内容 |
| 95 | 数码 | 数码产品、硬件 |
| 207 | 软件工程 | 编程、开发工具 |
| 231 | Web 开发 | 前端、后端、全栈 |
| 258 | 开源 | 开源项目介绍 |
| 208 | 人工智能 | AI、机器学习、LLM |
| 22 | 鬼畜 | 恶搞、二创 |
| 244 | 知识 | 科普、教育 |

## 标签建议

### 通用标签
- 编程、技术、教程、前端、后端

### AI 相关
- AI、人工智能、大模型、LLM、Claude、ChatGPT、AI编程

### 开发工具
- 开发工具、效率工具、编程工具、IDE

### 按场景选择
- 技术讲解：`技术分析` `深度解读` `程序员`
- 教程演示：`零基础教程` `手把手` `入门教程`
- 新闻分析：`科技资讯` `行业动态` `技术趋势`

## ffmpeg 字幕命令

### 硬字幕烧录（推荐）

将字幕直接烧录到视频画面中，兼容所有平台：

```bash
# 基本烧录
ffmpeg -i raw_video.mp4 \
  -vf "subtitles=subtitle.srt" \
  -c:a copy \
  final_video.mp4

# 自定义样式
ffmpeg -i raw_video.mp4 \
  -vf "subtitles=subtitle.srt:force_style='FontName=Noto Sans CJK SC,FontSize=18,PrimaryColour=&HFFFFFF&,OutlineColour=&H000000&,Outline=2,MarginV=25'" \
  -c:a copy \
  final_video.mp4

# 竖屏视频（1080x1920）
ffmpeg -i raw_video.mp4 \
  -vf "subtitles=subtitle.srt:force_style='FontSize=22,PrimaryColour=&HFFFFFF&,OutlineColour=&H000000&,Outline=2,MarginV=30'" \
  -c:a copy \
  final_video.mp4
```

### 软字幕嵌入

将字幕作为轨道嵌入视频（部分平台支持）：

```bash
ffmpeg -i raw_video.mp4 \
  -i subtitle.srt \
  -c copy \
  -c:s mov_text \
  final_video_soft.mp4
```

### ASS 字幕样式参考

如果需要更精细的样式控制，先将 SRT 转为 ASS：

```bash
ffmpeg -i subtitle.srt subtitle.ass
```

然后编辑 ASS 文件中的 `[V4+ Styles]` 部分：

```ini
[V4+ Styles]
Format: Name, Fontname, Fontsize, PrimaryColour, SecondaryColour, OutlineColour, BackColour, Bold, Italic, Underline, StrikeOut, ScaleX, ScaleY, Spacing, Angle, BorderStyle, Outline, Shadow, Alignment, MarginL, MarginR, MarginV, Encoding
Style: Default,Noto Sans CJK SC,18,&H00FFFFFF,&H000000FF,&H00000000,&H80000000,-1,0,0,0,100,100,0,0,1,2,1,2,10,10,25,1
```

### 硬字幕 vs 软字幕

| 特性 | 硬字幕 | 软字幕 |
|------|--------|--------|
| 兼容性 | 所有平台 | 部分平台不支持 |
| 可关闭 | 不可 | 可（如平台支持） |
| 画质影响 | 轻微（字幕区域不可压缩） | 无 |
| 制作难度 | 简单 | 简单 |
| **推荐** | **通用发布推荐** | 仅 YouTube 等支持的平台 |

## 发布前检查清单

1. [ ] 视频文件完整，可正常播放
2. [ ] 字幕时间轴准确，无偏移
3. [ ] 标题符合各平台长度限制
4. [ ] 描述包含关键信息和标签
5. [ ] 各平台账号已登录（cookie 有效）
6. [ ] 网络连接稳定（上传大文件需要）

## 发布后操作

1. 检查各平台视频是否正常显示
2. 检查字幕是否正常显示
3. 检查封面是否正常（部分平台需要单独上传封面）
4. 分享链接到社交媒体
