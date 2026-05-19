# Kedou Capabilities Reference

## Sources Learned

- `https://www.kedou.life/`
- `https://www.kedou.life/downloader`
- `https://www.kedou.life/extract`
- `https://www.kedou.life/tutorial/1760691062387630082`
- `https://www.kedou.life/tutorial/1846204560501735425`
- `https://www.kedou.life/tutorial/1833062937060278274`
- `https://www.kedou.life/tutorial/1938942417280008193`
- `https://www.kedou.life/caption/subtitle/youtube`
- `https://www.kedou.life/etext/xiaohongshu`
- `https://www.kedou.life/article/2018192195007905793`

OpenCLI note: on Leo's machine, use `opencli browser <session> open <url>` followed by `opencli browser <session> extract --chunk-size ...`. Avoid `opencli web read` for Kedou because it previously captured a Chrome extension overlay.

## Page Families

Top-level:

- `/`: homepage and direct/list parser.
- `/downloader`: downloader capability page.
- `/extract`: video extraction platform hub.
- `/tutorial`: tutorial area.
- `/blog`: blog/article index.
- `/charge`: VIP/member entry point.

Video extraction pages discovered:

- `/extract/bilibili`, `/extract/cctv`, `/extract/douyin`, `/extract/gzh`, `/extract/haokan`, `/extract/ixigua`, `/extract/kuaishou`, `/extract/miguvideo`, `/extract/sohu`, `/extract/tiktok`, `/extract/twitter`, `/extract/weibo`, `/extract/xiaohongshu`, `/extract/xpc`, `/extract/youtube`.

Subtitle pages:

- `/caption/subtitle/bilibili`, `/caption/subtitle/youtube`, `/caption/subtitle/wetv`, `/caption/subtitle/youkutv`, `/caption/subtitle/iq`, `/caption/subtitle/dailymotion`, `/caption/subtitle/ted`, `/caption/subtitle/viki`, `/caption/subtitle/vimeo`, `/caption/subtitle/weverse`.

Danmaku pages:

- `/caption/scrolling/bilibili`, `/caption/scrolling/vqq`, `/caption/scrolling/youku`, `/caption/scrolling/iqiyi`, `/caption/scrolling/douyin`, `/caption/scrolling/mgtv`, `/caption/scrolling/ixigua`.

Lyrics pages:

- `/caption/lyric/netease`, `/caption/lyric/yqq`, `/caption/lyric/kugou`, `/caption/lyric/kuwo`, `/caption/lyric/qianqian`.

Text extraction pages:

- `/etext/zhihu`, `/etext/xiaohongshu`, `/etext/csdn`, `/etext/cnblogs`, `/etext/jianshu`, `/etext/wenku`, `/etext/phpcn`, `/etext/51cto`, `/etext/jb51`.

## Web Parser Model

- Direct parse: parse only visible media on the current page.
- List parse: parse a video/image selection list when the page contains one.
- Input: browser URL or app share link.
- Output: parse result with downloadable/viewable resources such as video, audio, cover, subtitle, or other extracted material depending on platform.

## Downloader Model

Downloader capabilities learned from public docs:

- Resume, batch download, multi-thread segmented download.
- Video sniffing with built-in browser and external application sniffing when HTTPS certificate is installed.
- Homepage/playlist/list extraction for sources such as Douyin user home/short drama list, YouTube channels/playlists, Kuaishou user home, Bilibili user home/collections, Xiaohongshu user home, Xinpianchang user home, Xigua home.
- Favorites/likes/history/search extraction for selected platforms, including Douyin, Bilibili, Xiaohongshu, Kuaishou, Haokan, and others.
- Download resource types: video, audio, cover images, subtitles, danmaku.
- Toolbox: audio/video merge, TS segment merge, file merge, audio extraction.

Recommended defaults:

- Keep default config first.
- Task count around `2` or `4`.
- Avoid excessive max connection/thread count because it increases memory use and can trigger target-platform rate limits.
- If no downloader proxy is configured, downloader follows the system proxy.

## Cookie Boundary

Kedou docs describe cookies for target-platform batch parsing and high-quality/list workflows. Operational rules:

- User must configure cookies locally in Kedou/downloader or browser.
- Never ask the user to paste raw cookie values into chat.
- Never write raw cookie values to Knowledge Hub.
- If a workflow fails, ask the user to refresh the target-platform login/cookie locally and retry.

## Current Update Notes

V2.0.1 public article confirms:

- YouTube 403 download fixes.
- Bilibili dynamic batch extraction support.
- Bilibili image/GIF download optimization.
- Douyin batch audio fix for some extracted videos.
- Duplicate detection after batch extraction.
- Video codec display after custom-name downloads.

## Safety Boundary

Kedou states it does not cache third-party videos and that videos/images belong to the relevant sites and creators. Use workflows only for authorized content, personal learning, research, backup, or material with permission.

