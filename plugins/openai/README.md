# Velo for ChatGPT and Codex

OpenAI's plugin package for Velo. One package serves ChatGPT and Codex. OpenAI never reads this repo: we build a ZIP from this folder and upload it at [platform.openai.com/plugins](https://platform.openai.com/plugins). This README stays out of the ZIP.

| File | What it is |
| --- | --- |
| `plugin.json` | Manifest in the [Agent Plugins](https://agent-plugins.org) format. `extensions.com.openai` holds the listing, the review test cases and the release notes. |
| `mcp.json` | The Velo MCP server, `https://api.usevelo.ai/mcp`. No auth block: ChatGPT reads our OAuth metadata and registers itself (dynamic client registration). OpenAI documents an `extensions.com.openai.auth` override, but the Agent Plugins schema rejects it, and we don't need it. |
| `skills/velo-video/` | The Claude plugin's skill and its prompt library (`references/prompt-library.md`), with provider-neutral wording, and uploads that pass files attached in the chat straight to `upload_file`. Keep both in step with `plugins/claude`: only the upload step differs. |
| `assets/velo-icon.svg` | The Velo icon at 480 x 480. OpenAI needs SVG icons at least 48 x 48; the Claude copy is 20 x 20. |

## Try it before it's listed

- **ChatGPT:** in [ChatGPT Plugins](https://chatgpt.com/plugins), choose **+**, then **Add custom MCP server**. Enter `https://api.usevelo.ai/mcp`, choose OAuth, then **Create as a plugin**. Tools that change things, such as `create_video`, need a Business, Enterprise or Edu workspace with developer mode on (set by a workspace admin). After a backend deploy that changes tools, press **Refresh** on the connection.
- **Codex:** add the repo with a sparse checkout of only the Codex marketplace and this folder, then install and test from the ChatGPT desktop app:
  ```sh
  codex plugin marketplace add lookup-engg/velo-mcp --sparse .agents/plugins --sparse plugins/openai
  ```
  Without `--sparse`, Codex also reads the Claude marketplace (`.claude-plugin/marketplace.json`, which OpenAI supports as a legacy format), and would list the Claude plugin beside this one under the same name, `velo`.

## Build and submit

```sh
scripts/build-openai-zip.sh   # prints dist/velo-openai-<version>.zip
```

Upload the ZIP at platform.openai.com/plugins (**Upload new or existing plugin**), then:

1. **MCPs → Connect:** connect `https://api.usevelo.ai/mcp` and sign in with the reviewer account so OpenAI can scan the tools.
2. **Domain verification:** the portal shows a token. Set it as the backend's domain verification env var, so `https://api.usevelo.ai/.well-known/openai-apps-challenge` returns it.
3. **Review information:** enter the reviewer account's email and password. It must sign in without MFA, magic links or email codes, and have sample videos (the test cases look for "my latest Velo video").
4. **Submit for review**, then **Publish plugin** once approved.

For a new version: raise `version` in `plugin.json`, build and upload again. Tool changes on the server don't need a new ZIP: OpenAI rescans them daily and reviews each new tool.



## Rules to keep

From OpenAI's [plugin guidelines](https://developers.openai.com/plugins/plugin-guidelines):

- No pricing, plans, upgrades or links to checkout in the listing, skill or tool results. Saying that a step needs more credits is allowed.
- Every tool keeps explicit `readOnlyHint`, `destructiveHint` and `openWorldHint` annotations (the backend sets all three).
- The display name stays "Velo": no "MCP" or "Plugin" next to the brand.
