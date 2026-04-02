# video-creator

AI-driven technical video creation and multi-platform publishing workflow for Claude Code.

## What It Does

An end-to-end video production pipeline that covers:

1. **Topic Interview** — Collects video parameters (topic, audience, style, duration, resolution, TTS preferences)
2. **Video Generation** — Creates video with Remotion + generates voiceover with edge-tts
3. **Subtitle Loading** — ASR transcription via VideoCaptioner + burns hard subtitles with ffmpeg
4. **Multi-platform Publishing** — Publishes to Bilibili, YouTube, Douyin, etc. via social-auto-upload

## Install

```bash
npx skills add Zourunfa/video-creator-skill
```

Or manually copy `SKILL.md` and `references/` into your `.claude/skills/video-creator/` directory.

## Trigger Keywords

做视频, 生成视频, 教学视频, 技术视频, 录制视频, 制作教程, video, remotion video, 发视频, 发B站, 发布视频, 字幕, 配音

## Requirements

- [Remotion](https://www.remotion.dev/) — React-based video rendering
- [edge-tts](https://github.com/rany2/edge-tts) — Microsoft TTS for voice generation
- [VideoCaptioner](https://github.com/WEIFENG2333/VideoCaptioner) — ASR subtitle generation
- [ffmpeg](https://ffmpeg.org/) — Video processing
- [social-auto-upload](https://github.com/dreammis/social-auto-upload) — Multi-platform publishing

## Usage

In Claude Code, type:

```
帮我做一个关于 XXX 的技术视频
```

The skill will guide you through the 4-phase workflow interactively.

## License

MIT
