---
name: velo-video
description: >
  This skill should be used when the user wants a video made with Velo, such as
  "make a video with Velo", "make an explainer / product demo / launch video",
  "turn this PDF (or deck, or screen recording) into a video", "make a video of this
  website", or "a video presented by an avatar". It also applies when following a
  Velo video ("check on my Velo video", "is my video ready?"), when Velo asks the
  user something (the brief, which Assets to use, script approval, a voice or an
  avatar), when changing a draft, when exporting or sharing a finished video, when
  browsing, adding, replacing or removing files in the workspace's Velo Assets, and
  when creating or renaming a workspace library, changing who can see it, turning
  its public link on or off, or adding a video to one or taking it out, and when
  asking which Velo workspace is in use or switching to another of their workspaces,
  and when the user wants a word spelled or pronounced the same way in every video
  ("how to say", "pronunciation").
---

# Making videos with Velo

Velo makes animated, narrated videos: explainers, product demos, training modules, pitch and launch videos, motion graphics and social clips. It works from a brief, a document, a screen recording, a public website or an AI presenter. Velo's own agent builds each video in a Velo chat; the Velo tools start it, relay the conversation and hand back the links.

The role here: write Velo a short brief that says what the video should achieve, show the user everything Velo says and asks, send back the user's answers and changes, and give them the links. Prompting Velo covers how to word what goes to Velo.

## How results read in chat

- Show every link Velo returns as a short markdown hyperlinks, such as [Open your video](url), [Add your files](url) or [Open Assets](url). Never paste the raw URL, and never build or guess one.
- Keep IDs (`chat_id`, voice, avatar, asset, option and scene IDs) out of chat. Use them only in tool calls.
- Use names and labels in every reply, confirmations included. Map the user's choices back to its ID when calling a tool.
- Say times and durations in plain words: "about 2 minutes", "an hour ago".
- Describe choices and next steps in everyday language.

## Start a video

1. **Add files first, if there are any.** A document, a recording, audio, images or a logo reaches Velo through `upload_file`.
   - Files the user attached in this conversation: pass them in `files`. Velo adds them directly and returns them in `files`. Any it couldn't take come back in `refused`, with the reason and an `upload_page_url` for adding them another way.
   - Any other file, such as one saved on the user's computer: call `upload_file` with no `files`. Give the user the returned `upload_page_url` as a link: they add the files in their browser and choose **Done uploading**. Wait until the user says they've uploaded the files, then call `list_files` with the returned `chat_id` to confirm the files arrived. It waits briefly while a file is still uploading.
   - To upload more files, call `upload_file` again with the same `chat_id` for a fresh link.
   - A file already in the workspace's Assets needs no upload: see Assets.
2. **Start it with `create_video`.** Write `message` as a short brief for Velo, 2 to 5 sentences, from the whole conversation:
   - Say what the video is about, what each attached file shows, and the conditions the user set (length, audience, tone, a script review first).
   - Describe files only by what they show ("the attached deck is our Q3 pitch"), never by where they came from or how they were fetched.
   - Shape it as "Prompting Velo" describes, from what the user said and gave. Leave out any script, scene list or facts dump of your own, and any detail the user left open. Velo's agent asks questions for what it needs.
   - If files were uploaded, pass that `chat_id`. The waiting files go with it. `files_left` says how many still wait for the next message; `files_refused` names any Velo couldn't take, with the reason.
3. **Pick the `flow`** that matches the request:

| flow | Use it for | Needs first |
| --- | --- | --- |
| `auto` | A topic, a brief, or a public website (put the URL in `message`; Velo opens it in its own browser, so no recording is needed). | A `message` |
| `upload_pdf` | A video from a document (PDF, deck). | The document, through `upload_file` |
| `upload_recording` | Polishing a screen recording. | The recording, through `upload_file` |
| `record_yourself` | A video of the user talking. | That video, through `upload_file` |
| `generate_with_avatar` | A video presented by an AI avatar or user's clone. | Nothing |

- Pass `voice_id` or `avatar_id` only for one the user already chose (see Voices and avatars). Either one needs a `message` too.
- Pass `template_id` only when the user asked for a template (see Templates).
- Pass `asset_ids` only for files the user chose from Assets (see Assets). It needs a `message` too.
- If the user wants to review the script before Velo builds the video, say so in `message`, even for a video without narration.
- Starting a video never approves a later script.

## Follow it

Call `get_video_status` with the `chat_id` to get status of the video.

The user can also work on the video in Velo itself. `since_you_looked` lists what changed there since your last look. Acknowledge what the user did there in one line, without asking or showing it again, and apply their next request to the video as it is now. A question Velo asked since then is the one thing to show them.

| status | What it means | Next |
| --- | --- | --- |
| Working | Velo's agent is on it. `message` is its latest progress line. | Call `get_video_status`. |
| Needs your answer | Velo is waiting on the user: a question in `message`, a `pending_question`, or both. | Show it in full (see "When Velo asks"). |
| Needs your action | Velo's browser needs the user, for example to sign in to a site (`pending_action`). | Send the user to `preview_url`: they choose Take control, sign in if needed, then Resume agent. That sign-in happens in Velo's browser, never in this chat. Once they're back, check the status again; sending a message doesn't resume that browser. |
| Draft ready | A draft to watch at `preview_url`. `message` is Velo's reply and may ask something. | Show `message` and the link. Send answers or changes with `edit_video`. Export only when the user asks. |
| Finishing | The final video is rendering. `render_percent` says how far along. | Call `get_video_status`. |
| Done | The video is finished. `video_url` is its share page, present when sharing is on. | Give the user the links. |
| Out of credits | User has exhausted credits on Velo. `error.message` says why and how to resume. | See Credits. |
| Failed | The last step didn't finish. `error.message` says what to do next. | Show it. Trying again (`edit_video` or `export_video`) is the user's call. |

When `fix_attempt` is present, Velo is repairing a failed export on its own: keep following it.

## When Velo asks

Velo asks one step at a time: usually the brief, then the script, then the voice. An avatar video also asks who should be the presenter. A new video in a workspace with Assets may also ask which files to use (see Assets). A question can come at any status, Draft ready included, so read `message` on every result.

Present every question in plain chat text, whether it arrives in `message` or `pending_question`. Do not use native forms, question widgets or elicitation to collect the answer. Keep the full question: every choice (with its category), every optional field, and any script content. List every returned choice; don't trim the list.

### Questions in `message`

- Reply with `edit_video` and no `pending_question_id`, written for Velo in a few sentences with the context it needs, keeping every condition the user gave.
- If the user may have answered on the Velo page meanwhile, refresh `get_video_status` first: a question in `message` has no stale-question protection.
- A `message` that ends as truncated text "…" is partial. The full text is in the Velo chat at `preview_url`.

### `pending_question`

- Pass its `id` as `pending_question_id`, with the user's reply in `message` (as they gave it) or their choices in `answers`. Keys for `answers` come from `pending_question.answer_fields`; values are the chosen option IDs, the user's typed text, or null to skip an optional field. Partial answers are accepted. Any question answered through `answers` is written out by Velo itself, so a pick sent in `answers` isn't repeated in `message`: beside `answers` it carries only what they leave unsaid (a condition or a change), and stays empty for a plain pick.
- Ask optional fields in text and mark them optional. The user may answer or skip them; don't skip them silently.
- `free_text_ok: false` means a step only the Velo page can do, such as recording a take or choosing music. Send the user to `preview_url` and don't answer it with `edit_video`. Once they say it's done, check `get_video_status`.
- A result with `submitted: false` means that question was already answered or replaced, so nothing was sent; the result carries the latest state. Don't apply the old reply to the new question, and don't resend it without a question ID.

### The script

The script arrives as a `pending_question` of kind `script-review`, with every scene's narration in `scenes`.

- Show the user every scene, word for word, by scene number or title. Never summarize or shorten the narration.
- Wait for the user's explicit approval of this version. The first request, a voice choice or opening the voice library is not approval. Approving a script starts generating the narration.
- For a clear, unconditional approval, send `message="approve"` with the script's `pending_question_id`. If the reply includes changes or conditions, or is ambiguous, send it as the user gave it instead.

### Answering for the user

Answers and selections come from the user. Choose for them only when they explicitly ask, and then say so in `message` ("the user asked Velo to choose the voice").

## Workspaces

A Velo user can belong to several workspaces. The connection works in one of them at a time: its videos, voices, libraries, Assets, brand kit and credits are that workspace's.

- `list_workspaces` says who the user is in Velo (`you`: name and email) and lists their workspaces with `workspace_id`, `name`, `role`, `current` (the one in use now) and `usable` (the Velo agent is on there). Call it when they ask which workspace they're in, or name another one.
- `switch_workspace` moves the connection to another of their workspaces, by `workspace_id` from `list_workspaces`, on their request. When you only inferred it from a request ("make this in Acme"), ask first: a name in a request is often a customer, not a workspace. New videos, lists, libraries and Assets then come from the new workspace. A video made before keeps working in its own workspace by its `chat_id` (status, changes, export, sharing), so earlier chats carry on as they were. A workspace that isn't theirs, or has the agent off, is refused and nothing moves.
- Confirm the switch by the workspace's name, never by id.

## Voices and avatars

- `list_voices` and `list_avatars` list what the user can use, grouped as their own, shared in the workspace, then public. Show them in those groups, by name.
- A `pending_question` that asks for a voice or avatar carries its own choices: answer from those. Use the catalogs when Velo asks in `message` without choices, or when the user wants to choose or change one.
- `voices_url` opens Velo's voice library, where the user can listen before choosing. Opening it selects nothing.
- Send the pick with `edit_video`. For a voice or avatar question, put it in `answers` (keys from `answer_fields`) with the `pending_question_id`. As with any question answered through `answers`, `message` holds only a condition the user added, or nothing, since Velo writes the answer out itself.
- For a voice or avatar chosen from the catalogs instead, send the user's words in `message` and the ID as `voice_id` or `avatar_id` (an avatar can take a `voice_id` too).
- Show only previews Velo supplies. Don't add stock or illustrative portraits.

## Templates

- `list_templates` lists the templates the user can start a video from: Velo's curated ones first, then the workspace's own. Each has `template_id`, `name`, `description`, `categories` and `workspace_own` (true for one the workspace saved). A workspace template also has `made_by`, the name of the person who made it. `query` narrows the list by name, description and categories, ignoring case.
- A template sets a video's look: styling, transitions, effects, and often its voice and presenter. Use one only when the user asks for a template, names one ("our launch template"), or wants a video like an earlier one.
- Choose by name, description and categories. When several fit or none clearly does, show the user the names and let them choose.
- Pass the chosen `template_id` to `create_video`. An id the workspace can't use is refused with `not_found` before anything starts.
- To use a template in a video already started, ask for it in `edit_video` ("Use our launch template"): Velo's agent applies it.

## Assets

Assets is the workspace's shared library of files: images, video, audio, and documents such as PDFs, slides and HTML pages. Members add a file once and use it in any video.

- **Browse and search:** `list_assets` lists the files. `query` matches file names; `kind` narrows to `image`, `video`, `audio` or `document`. While `has_more` is true, pass `offset` for the next page. Show each file by name, with its kind, who added it (`added_by`: "you" or their name) and when. When it matters, also say how many videos use it (`used_in_videos`, with the ones the user can open in `used_in`: open one with `get_video_status` and its `chat_id`) and whether Velo has finished reading it (`summary_status`: `pending` or `processing` while it reads, `failed` if it couldn't). It returns names and details, not what's inside a file or its description.
- **Open a file:** `view_url` opens it for the user and stops working after about an hour. Show it as a link only when the user wants to see the file, never hand it on, and call `list_assets` again for a fresh one. `assets_url` opens Velo's Assets page.
- **Add to Assets:** files the user attached in this conversation go in `files` to `upload_asset`. Velo adds them directly and returns them in `added`. Any it couldn't take come back in `refused`, with the reason and an `upload_page_url` for adding them another way. For any other file, call `upload_asset` with no `files` and give the user the returned `upload_page_url` as a link: they add the files in their browser and choose **Done uploading**. Wait until the user says they're done, then call `list_assets` to confirm the files arrived.
- **Assets or one video:** a file in Assets is for the whole workspace and can go in any video. `upload_file` adds a file to one video only. Use `upload_asset` only when the user wants the file in Assets.
- **Use Assets in a new video:** pass the files the user chose as `asset_ids` in `create_video`, at most 10, with a `message`. Velo then doesn't ask which assets to use. When the user names a file loosely ("our logo"), find it with `list_assets`, and ask which one when several match.
- **The asset question:** without `asset_ids`, a new video in a workspace with more than 3 files in Assets asks which files to use. With 3 or fewer, Velo uses the ones that fit without asking and says which it used. It arrives as a `pending_question` of kind `asset-picker`, with Velo's suggestions in `options`, best first, and `assets_url` beside it. List every option by name, with its label, and say the user can pick up to 10, name others from Assets, or use none. They can browse with `list_assets` or on the Assets page. Send the picks with `edit_video`: the `pending_question_id` and `answers={"assets": [...]}` with their IDs, from the options or from `list_assets`. `[]` means use none.
- **Replace a file:** when the user wants a newer version of a file in Assets, call `replace_asset` with its `asset_id` from `list_assets` and the new file the user attached in `files` (one file). Velo puts it in place and returns it in `replaced`: the same file, still with its original uploader and date, with Velo reading it again; videos that already used the old file keep it, stay listed as using it and show as outdated until they're updated. Without an attached file, it returns `assets_url`: give it as a link and say they choose **Replace…** in that file's menu and tell you when it's done. Only a workspace admin or owner can replace a file, even one the user added themselves; a refusal comes back with the reason.
- **Videos using a file:** `asset_videos` takes the file's `asset_id` and lists the videos that use it, outdated ones first. Each has its title, a chat link (`chat_url`), `up_to_date`, and, when outdated, `uses_old_file` (the name of the older file it still holds) and `can_update`. When `can_update` is false, `why_not` says why: only the person who made a video can have it updated, and not while the agent is working on it. `outdated_not_yours_to_open` counts outdated videos in chats the user can't open; they aren't listed. Show each by title as a link to its chat.
- **Update videos after a replace:** once the file is replaced (or when the user asks to update the videos using a file), call `asset_videos`, show the outdated ones and ask which to update. Never pick for the user, and never start every outdated video unasked. Then call `update_videos_with_asset` with the `asset_id` and only the `video_id`s they chose, at most 20 at a time, and say once that each update is an agent turn that uses credits. Updates run in the background: give the user the `chat_url` links from the reply instead of waiting. A video the agent is already working on, one already up to date, or one made by someone else is skipped with the reason: pass it on. If credits run out, that video and the rest aren't started: see Credits.
- **Remove a file:** no tool deletes from Assets. Give the user `assets_url` as a link and say a workspace admin or owner can remove the file there. Never say a file was deleted.

## Changes, export and links

- Changes go through `edit_video` with the video's `chat_id`, worded as Prompting Velo describes. New files go through `upload_file` with that `chat_id` first; they go with the next `edit_video`.
- While the video is Working, `edit_video` returns `busy`. Follow it with `get_video_status` and send once the status changes.
- `export_video` renders the current draft into the finished video. Call it only when the user asks for the final video, then follow `get_video_status` until Done. Rendering is free; automatic repairs after a render error may use credits. Calling it again while rendering, or after a render, starts nothing.
- `preview_url` is the video's Velo chat, where the user watches the draft, answers and edits.
- `video_url` is the finished video's share page, not a file download.
- `list_videos` lists the user's videos, most recently active first, with each one's status and link. `status` narrows it to `draft` or `rendered`; pass `next_cursor` back as `cursor` for the next page. Use it to find a video the user mentions.

## Libraries

A library is a shared collection in the workspace where exported videos are published for members to watch. Every workspace has a default one, General, which already holds every video on its own.

- `list_libraries` lists the libraries the user can see, with `library_id`, `name`, `visibility`, `is_default`, `published` (whether it is on the Velo Public Library) and `video_count`. For a workspace admin or owner, `public_library` says whether that page is on and gives its `url`. Call it when the user names a library. The libraries a video was added to, besides General, are on its status and in its `list_videos` row as `libraries`.
- `create_library` makes a new library with the user's `name`, `public` (every member sees it, the default) or `private` (the creator, admins and members they add in Velo). Call it only when the user asks for a new library: names can repeat, so when they say "the X library", find it with `list_libraries` first. The reply's `library_id` goes straight to `add_to_library`.
- `add_to_library` puts one exported video in a library by `chat_id`; omit `library_id` for General, which already holds every video, so that call reports `added: false`. Only an exported video with its share link on can go in, even while it is being edited again: one never exported is refused, and whether to export it is the user's decision (say so, don't export); one whose share link was turned off is turned back on in Velo. A video can be in any number of libraries, and adding it to one leaves the others. `added: false` also means it was already in that library. The reply names the library.
- `remove_from_library` takes a video out of one library by `chat_id`, on the user's request in this conversation. Pass `library_id` when it is in more than one. When it is in several and none is named, the reply lists them so the user can choose. The video, its share link and its other libraries stay. `removed: false` means it wasn't in a library besides General, and General itself can't be left.
- `rename_library` renames a library to the `name` the user gave, on their request. Only its maker or a workspace admin may, and General's name can't change. Take `library_id` from `list_libraries`.
- `set_library_visibility` makes a library `public` (every workspace member sees it) or `private` (its maker, admins and the members added to it in Velo), on the user's request. Only its maker or a workspace admin may, and General stays public. Changing the visibility of a library on the Velo Public Library takes it off; the reply says so.
- `set_library_share_link` turns a library's public link `on` (the same link as before), `off`, or `regenerate` (a new link; the old one stops working for good). Turning it on makes a public link: anyone who has it, outside the workspace too, can watch the library's videos, so confirm with the user before turning it on or replacing it. `share_url` is in the reply while the link is on. Only the library's maker or a workspace admin may. This link is not the Velo Public Library.
- `set_velo_public_library` puts a library on the workspace's Velo Public Library (`published: true`), the page outside viewers sign in to and watch, or takes it off (`false`), on the user's request. Only a workspace admin or owner may. Only a library public to the workspace can go on; any library can come off. Confirm with the user before putting one on: its videos become visible to the page's viewers, and for General that is every video in the workspace whose share link is on. Turning the page itself on or off is in Velo's settings; the reply says when the page isn't live yet. When the user asks for "our public library link", it is `public_library.url` from `list_libraries`.
- Confirm the library by the name in the reply, never by id.

## Pronunciations

The workspace's pronunciations list the names, places, products and acronyms the workspace's videos use: how each is spelled on screen and how every voice says it. Every video follows them.

- `get_pronunciations` reads them: each term's spelling, `sounds_like`, `ipa`, `letter_by_letter` and `note`. `active` is false on a free plan, where the terms are kept but not used; `can_add` says whether this user may add terms.
- When the user wants a word spelled or said the same way in their videos ("it's SAH-nus, not SAY-nus", "always write it as PLASS"), fix the current video with `edit_video` in the user's words, then suggest adding the word to the workspace's pronunciations so every video follows it. One suggestion per word.
- `add_pronunciation` adds it, only after the user asks or agrees: the `term` as it is spelled, `sounds_like` in the user's words (a respelling, a comparison or stress notes), `letter_by_letter` for acronyms said that way, an optional `category` and `note`. It needs a workspace admin on a paid plan; a refusal says what the user can do instead, so pass that on.
- Terms are changed and removed in Velo, at `pronunciations_url`. A word that is already there with a different sound is changed there.

## Prompting Velo

Velo's video creation is intent and outcome driven: it works best from a simple explanation of what the finished video should achieve. Lead every `message` to Velo with that outcome in plain words, then add only what the user said, attached or connected. A detail the user didn't give stays out, or Velo is told to ask about it.

### A first brief

Start with the outcome; add the other points only when the user gave them.

- **The outcome:** what the finished video should achieve, and for whom. "A demo" is a topic; "a 4-step demo for new trial users that ends on a shared report" is an outcome.
- **Point Velo at the real thing:** the attached screenshots, document or recording (by what each shows), a URL, or a source the user connected in Velo, such as a knowledge base or an app, by name. Tell Velo to follow it.
- **Concrete actions over intent:** what the viewer sees happen on screen ("click Connect, choose a source, land on the dashboard"), not "demonstrate the integration".
- **Emphasis:** what the viewer must remember, and what to keep brief.
- **Gaps:** tell Velo to leave out or ask about anything the sources don't cover, so the video never shows a step that doesn't exist.
- **Style the user named:** narration (pace, tone, speaking to the viewer as "you" or staying neutral, a line per step or lighter narration) and visuals (subtle or punchy effects, cut pace, heavy or minimal on-screen labels, overall feel).

When a product video has no real material yet, suggest once that the user adds screenshots of the real UI, a help article or a URL: real screenshots are the fastest way to an accurate product video. Then start with what they have.

### A change request

A draft is usually close. Word each change so Velo places it exactly:

- **Lock what works:** end nearly every change with "Change only this; leave everything else exactly as it is."
- **Anchor three ways at once:** the narration words, the on-screen component, and where it sits. "When the narration says 'choose the report type', box the 'Report type' field" places it; "add a box near the top" doesn't. Quote narration from the script shown in this conversation, when there is one.
- **Time it to the narration:** an effect lands when the narration reaches its line, not at the start of the scene. Name the trigger line, and the timestamp when the user gave one.
- **Problem, target, and what to avoid:** what's wrong now, what right looks like, and the feel to rule out.

When a change aims at one moment and the user hasn't said which line, component or time, ask them before sending it.

### Bounding boxes and the cursor

Put these rules in any request that adds or changes a bounding box or the cursor:

- **Bounding boxes:**
  - Only one box on screen at a time: remove the previous one before the next.
  - Ground the box to the narration words, the component and where it sits on screen.
  - Size it to the component's actual height and width, built from the component's centre with 5px padding so it never overlaps the component.
  - Thin border, colour #242424, with no caption or label text.
  - Skip the box when the component is the only thing on screen.
- **Cursor:**
  - It follows the same boxes and narration.
  - It points to the component and never covers or overlaps it.

### Sample prompts

[references/prompt-library.md](references/prompt-library.md) has a sample prompt for each kind of first video (product demo, support how-to, training, feature announcement) and each kind of change (focus and emphasis, on-screen graphics, narration, captions, structure and timing). Read it when writing a brief or a change, and customise the closest sample to the request: keep what the user gave, and shorten or drop the rest.

## Credits

- Every action that Velo's agent performs costs credits. The user can see how many they have left in Velo's billing settings.
- Out of credits (the status, or an `insufficient_credits` error): the request is saved. A workspace owner adds credits in Velo's billing settings (other members ask an owner), then the user presses Continue in the Velo chat at `preview_url`. Don't send the request again.

## Errors and retries

A failed call returns `code`, `message` and `retryable`, plus `retry_after_seconds` and `link` when they apply.

- `create_video` and `edit_video` are not safe to retry: a call whose result was lost may have started. After an unclear failure, check `get_video_status` (or `list_videos` for a new video) before sending anything again. The same holds for `export_video`.
- `retryable: true`: nothing was started. Wait `retry_after_seconds`, then make the same call again.
- `busy`: Velo is still working on this video. Follow it and send once it's done.
- `input_rejected`: nothing was started, and `message` says what to change. A step that belongs on the Velo page comes with `link`, the page to finish it on.
- `not_found`: no video with that ID in this workspace. Check `list_videos`.
- `not_allowed`: this connection can't do that. The user reconnects Velo.
- `rate_limited`: wait `retry_after_seconds`, then retry.

## Avoid

- Writing a script, scene list or details the user left open into the brief.
- Filling a sample prompt's [brackets] with guesses: a timestamp, component, emphasis or style the user didn't give.
- Answering Velo's questions or approving a script on the user's behalf.
- Summarizing Velo's script or questions: show them whole.
- Inventing URLs, voices, avatars, templates, assets or previews.
- Picking a template the user didn't ask for.
- Saying a file was deleted from Assets: no tool deletes one.
- Starting an update on a video the user didn't pick, or on every outdated video at once.
- Calling `get_video_status` again on any status other than Working or Finishing.
- Turning a library's public link on, or replacing it, before the user confirms.
