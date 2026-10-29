# Velo for Claude

**Create on-brand product videos.**

Create product demos, feature walkthroughs, customer onboarding videos, and internal training content with [Velo](https://www.usevelo.ai). Velo turns your Claude conversations, documents, and company knowledge into on-brand videos.

Connect your Velo workspace to combine existing conversation context with your company's product knowledge, source materials, and brand settings.

## What you can do with Velo

- **Create videos:** Generate videos from prompts, conversations, documents, URLs, and company knowledge.
- **Stay on brand:** Apply existing Velo brand settings to maintain consistency across videos.
- **Edit and update:** Revise videos using new product information, release notes, or updated training materials.
- **Find and access:** Retrieve existing videos and projects from your connected Velo workspace.
- **Track progress:** Check video creation status and access completed videos.

Start video creation from Claude and get completed videos in Velo to review, edit, and share. Turn existing context into videos without rebuilding briefs or transferring information between tools.

## What's included

- **Velo connector:** a remote MCP server at `https://api.usevelo.ai/mcp`. You sign in with your Velo account over OAuth; the plugin stores no keys.
- **`velo-video` skill:** teaches Claude Velo's workflow end to end. Claude writes Velo a short brief, follows the video's progress, shows you every question and the full script, sends back your answers, and hands you the links. Claude never approves a script for you.

## Requirements

- A Velo account and workspace. Sign up at [usevelo.ai](https://www.usevelo.ai).
- Credits in that workspace for making and changing videos.

## Install and connect

**claude.ai, Claude Desktop and Cowork:** install the Velo plugin from the directory, open the plugin's **Connectors** tab, choose **Connect** for Velo, and sign in. Velo asks you to approve access for your workspace.

**Claude Code:** install the plugin, run `/mcp`, select `velo`, and choose **Authenticate**. Your browser opens Velo's sign-in and consent page. The skill is available as `/velo:velo-video`.

To disconnect, remove the connection in Claude, or disconnect it in Velo under **Connectors → Velo MCP → Your connections**.

## Try it

- "Create a 60-second product walkthrough from feature announcement, highlighting what's new and how it works."
- "Turn this employee onboarding SOP into a step-by-step training video with narration and branded visuals."
- "Create a 60-second product explainer video using the avatar from my Velo workspace and the product details in this conversation."

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
| `export_video` | Renders the current draft into the finished video. Free. |

## Credits

Making and changing videos (`create_video`, `edit_video`) spends credits from your Velo workspace. Exporting is free, though automatic repairs after a render error may use credits. Workspace owners add credits in Velo's billing settings.

## Data handling

When you use the plugin, Claude sends Velo the brief it writes, your replies, and any files you add. Velo uses them to make your video in your workspace. Velo's handling of that data is covered by its [Privacy Policy](https://www.usevelo.ai/privacy) and [Terms of Service](https://www.usevelo.ai/terms).

## Support

Email [support@usevelo.ai](mailto:support@usevelo.ai).

## License

Proprietary. See [LICENSE](LICENSE).
