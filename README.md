# Velo MCP

Velo's MCP server (`https://api.usevelo.ai/mcp`) packaged for AI clients. The server itself lives in `velo-web-backend` (`app/velo_mcp`). This repo holds only what each client installs: its manifest, the connector URL, and the skill that teaches the agent Velo's workflow.

## Layout

| Folder | Client | Ships through |
| --- | --- | --- |
| `plugins/claude/` | Claude: claude.ai, Desktop, Cowork, Claude Code | Anthropic's plugin directory (plugin path `plugins/claude`), and the Claude Code marketplace in `.claude-plugin/marketplace.json` |
| `plugins/openai/` | ChatGPT and Codex | A ZIP built by `scripts/build-openai-zip.sh` and uploaded at platform.openai.com. Codex also reads `.agents/plugins/marketplace.json`; add the repo with `--sparse` so it skips the Claude marketplace. See [plugins/openai/README.md](plugins/openai/README.md). |

Each new client gets its own folder under `plugins/`:

| Client | Folder | Notes |
| --- | --- | --- |
| Cursor | `plugins/cursor/` | Plus a root `.cursor-plugin/marketplace.json` that points at it. See [Cursor plugins](https://cursor.com/docs/reference/plugins). |
| Gemini CLI | repo root | `gemini-extension.json` has to sit at the repo root. See [Gemini CLI extensions](https://geminicli.com/docs/extensions/reference/). |

## Rules for a plugin folder

- **Self-contained.** A client installs only its folder, so every file it uses lives inside it. No symlinks, no `../` paths, no files shared across folders.
- **The path is permanent.** Anthropic's directory can't move a submission to another folder, so `plugins/claude` stays where it is.
- **Skill text is per client.** OpenAI requires provider-neutral wording ("the model", not "Claude"), and each client uploads files differently. Copy the skill into each folder and adapt it.
- **Raise `version`** in the folder's manifest with every release.

## Work on the Claude plugin

```sh
claude plugin validate plugins/claude   # the plugin
claude plugin validate .                # the marketplace
claude --plugin-dir plugins/claude      # try it in Claude Code
```

To install from GitHub instead: `/plugin marketplace add lookup-engg/velo-mcp`, then `/plugin install velo@velo`. While the repo is private, Claude Code needs a stored git credential (`gh auth setup-git`).

## License

Proprietary. See [LICENSE](LICENSE).
