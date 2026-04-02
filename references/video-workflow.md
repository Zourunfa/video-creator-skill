# 视频生成工作流详细指南

## Remotion 项目脚手架

### 新建项目

```bash
npm create video@latest my-video
cd my-video
npm install
```

### 项目结构

```
my-video/
├── src/
│   ├── Root.tsx              # 注册所有 Composition
│   ├── Video.tsx             # 主视频组件，组合所有场景
│   ├── scenes/
│   │   ├── Opening.tsx       # 开场动画（标题 + 主题）
│   │   ├── ContentSlide.tsx  # 通用内容场景
│   │   ├── CodeSlide.tsx     # 代码展示场景
│   │   ├── DiagramSlide.tsx  # 架构图/流程图场景
│   │   ├── TimelineSlide.tsx # 时间线场景
│   │   └── Closing.tsx       # 结尾（关注引导）
│   └── styles/
│       └── theme.ts          # 全局主题配色
├── public/
│   └── audio/                # TTS 生成的音频文件
├── remotion.config.ts
└── package.json
```

### Root.tsx 模板

```tsx
import { Composition } from "remotion";
import { Video } from "./Video";

export const RemotionRoot = () => {
  return (
    <Composition
      id="MyVideo"
      component={Video}
      durationInFrames={TOTAL_FRAMES}  // 根据音频总时长计算
      fps={30}
      width={1920}
      height={1080}
    />
  );
};
```

## 场景拆分建议

### 根据主题类型选择场景结构

#### 技术讲解类（如：源码分析、工具介绍）

```
Scene 1: Opening — 标题 + 主题引入 (10-15s)
Scene 2: Background — 背景介绍/事件回顾 (15-30s)
Scene 3-N: Main Content — 核心内容拆分 (每个 20-40s)
Scene N+1: Summary — 总结要点 (10-15s)
Scene N+2: Closing — 关注引导 (5-8s)
```

#### 教程演示类（如：手把手教学）

```
Scene 1: Opening — 标题 + 学习目标 (10-15s)
Scene 2: Prerequisites — 前置条件 (10-20s)
Scene 3-N: Steps — 逐步演示 (每个 15-30s)
Scene N+1: Result — 最终效果展示 (10-15s)
Scene N+2: Closing — 下期预告 (5-8s)
```

#### 新闻分析类（如：事件解读）

```
Scene 1: Opening — 标题 + 爆点引入 (8-12s)
Scene 2: Timeline — 事件时间线 (15-25s)
Scene 3-N: Analysis — 多角度分析 (每个 20-35s)
Scene N+1: Opinion — 观点总结 (15-20s)
Scene N+2: Closing — 互动引导 (5-8s)
```

### 每个场景的必备元素

1. **场景标题**：简洁明了，5 字以内
2. **TTS 旁白**：完整台词，中文，每句不超过 40 字
3. **画面描述**：Remotion 组件布局、颜色、动画效果
4. **时长估算**：基于 TTS 文本字数 × 语速

## 时长计算公式

### TTS 时长估算

```
单句时长(秒) = 字数 / 语速(字/秒)
语速参考：
  - 慢速：2.5 字/秒（edge-tts rate=-10%）
  - 正常：3.5 字/秒（edge-tts rate=+0%）
  - 偏快：4.0 字/秒（edge-tts rate=+10%）
  - 快速：4.5 字/秒（edge-tts rate=+20%）
```

### 帧数计算

```
durationInFrames = Math.ceil(audio_seconds × fps)
fps 默认 = 30

示例：
  音频 8.5 秒 → Math.ceil(8.5 × 30) = 255 帧
```

### 总时长验证

```bash
# 获取所有音频总时长
for f in public/audio/*.mp3; do
  ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$f"
done | paste -sd+ | bc
```

## 渲染命令

### 基本渲染

```bash
npx remotion render src/index.ts MyComposition output.mp4
```

### 高质量渲染

```bash
npx remotion render src/index.ts MyComposition output.mp4 \
  --codec h264 \
  --image-format png \
  --quality 85
```

### 渲染特定场景（调试用）

```bash
npx remotion render src/index.ts MyComposition output.mp4 \
  --frames=0-90  # 只渲染前 3 秒（0-90 帧 @ 30fps）
```

### 常用 Remotion 依赖

```json
{
  "dependencies": {
    "remotion": "^4.0.0",
    "@remotion/cli": "^4.0.0",
    "@remotion/player": "^4.0.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "typescript": "^5.0.0"
  }
}
```

## 画面设计建议

### 配色方案

#### 科技深色（推荐）
- 背景：`#0f172a`（深蓝灰）
- 主文字：`#f8fafc`（近白）
- 强调色：`#38bdf8`（天蓝）或 `#818cf8`（淡紫）
- 代码背景：`#1e293b`

#### 清新浅色
- 背景：`#f8fafc`（近白）
- 主文字：`#1e293b`（深蓝灰）
- 强调色：`#3b82f6`（蓝）
- 卡片背景：`#ffffff`

### 动画建议

- **进入动画**：使用 `<Fade>`、`<Slide>` 或 `<Scale>` 组件
- **文字动画**：逐字或逐行出现，保持与 TTS 节奏一致
- **转场效果**：场景间使用淡入淡出（0.5s）或滑动切换
- **强调效果**：关键信息使用放大、高亮、下划线动画

### 字体建议

- 标题：系统粗体 或 `font-weight: 700`
- 正文：系统中体 或 `font-weight: 400`
- 代码：等宽字体 `font-family: 'JetBrains Mono', monospace`
