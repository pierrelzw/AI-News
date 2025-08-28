# LLM & AI Agent 情报简报博客

本仓库用于每日发布「LLM & AI Agent 情报简报」，内容涵盖最新的大模型与智能体相关资讯、论文、项目等。

## 如何开启 GitHub Pages

1. 进入仓库 Settings → Pages。
2. 选择「Deploy from a branch」→ 选择 `main` 分支，目录选择 `/（root）`。
3. 保存后，站点将在 `https://<你的用户名>.github.io/<仓库名>/` 自动上线。

## 文章发布与管理

- 每日简报自动生成于 `_posts/` 目录，文件名格式为：`YYYY-MM-DD-llm-agent-briefing.md`。
- 如需手动新增文章，请在 `_posts/` 下按日期命名并填写标准 Jekyll Front Matter。
- 主页会自动列出最近文章，支持 RSS（`/feed.xml`）与 Sitemap（`/sitemap.xml`）。

## 本地预览（可选）

如需本地预览，可安装 Ruby 与 Jekyll，并运行：

```bash
bundle exec jekyll serve