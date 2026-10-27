# Velo for Claude

[Velo](https://usevelo.ai) makes finished, narrated videos: explainers, product demos, pitch and launch videos, motion graphics and social clips. It works from a short brief, a document or deck, a screen recording, a public website, or an AI presenter. This plugin connects Claude to your Velo workspace so you can start, guide, edit and export Velo videos without leaving the conversation.

## What's included

- **Velo connector:** a remote MCP server at `https://api.usevelo.ai/mcp`. You sign in with your Velo account over OAuth; the plugin stores no keys.
- **`velo-video` skill:** teaches Claude Velo's workflow end to end. Claude writes Velo a short brief, follows the video's progress, shows you every question and the full script, sends back your answers, and hands you the links. Claude never approves a script for you.

## Requirements

- A Velo account and workspace. Sign up at [usevelo.ai](https://usevelo.ai).
- Credits in that workspace for making and changing videos.

## Install and connect

**claude.ai, Claude Desktop and Cowork:** install the Velo plugin from the directory, open the plugin's **Connectors** tab, choose **Connect** for Velo, and sign in. Velo asks you to approve access for your workspace.

**Claude Code:** install the plugin, run `/mcp`, select `velo`, and choose **Authenticate**. Your browser opens Velo's sign-in and consent page. The skill is available as `/velo:velo-video`.

To disconnect, remove the connection in Claude, or disconnect it in Velo under **Connectors → Velo MCP → Your connections**.

## Try it

- "Make a 60-second explainer about our new onboarding flow with Velo."
- "Turn the attached pitch deck into a video."
- "Make a product demo video of https://example.com."
- "Make a short video presented by an avatar announcing our Q4 launch."
- "What's the status of my Velo video?"
- "Which voices can I use? Switch the narration to a warmer one."
- "Export the final video."

## Tools

| Tool | What it does |
| --- | --- |
| `create_video` | Starts a new video with Velo's agent from a brief, a document, a recording, a website or an avatar. Spends credits. |
| `edit_video` | Sends your reply, an answer to Velo's question, script approval or a change request to a video. Spends credits. |
| `get_video_status` | Gets a video's status, Velo's latest message and any question waiting for you. |
| `list_videos` | Lists your videos in the workspace, most recent first. |
| `upload_file` | Adds files (a document, a recording, images, a logo) to a video through an upload link. |
| `list_files` | Confirms which uploaded files are waiting to go to Velo. |
| `list_voices` | Lists the narration voices you can use. |
| `list_avatars` | Lists the AI presenters you can use. |
| `get_credit_balance` | Shows your workspace's remaining credits and plan. |
| `export_video` | Renders the current draft into the finished video. Free. |

## Credits

Making and changing videos (`create_video`, `edit_video`) spends credits from your Velo workspace. Exporting is free, though automatic repairs after a render error may use credits. Workspace owners add credits in Velo's billing settings.

## Data handling

When you use the plugin, Claude sends Velo the brief it writes, your replies, and any files you add. Velo uses them to make your video in your workspace. Velo's handling of that data is covered by its [Privacy Policy](https://www.usevelo.ai/privacy) and [Terms of Service](https://www.usevelo.ai/terms).

## Support

Email [support@usevelo.ai](mailto:support@usevelo.ai).

## License

Proprietary. See [LICENSE](LICENSE).
