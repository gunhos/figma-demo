# Claude Code — figma-demo

Flutter app built design-first: Claude designs in Figma, then implements in Flutter.

## Stack

- **Flutter** ≥ 3.4 / Dart ≥ 3.4
- **State**: `flutter_riverpod`
- **Routing**: `go_router`
- **Design**: Figma (file key `eAy75avd4oU9y0SyTuJCn5`)

## Local setup (one-time)

1. **Flutter SDK** — install from <https://docs.flutter.dev/get-started/install>, then run in this repo:
   ```
   flutter create .
   ```
   This fills in `android/`, `ios/`, `web/`, etc. without touching existing files.

2. **Bun** — used to run the Figma MCP socket server:
   ```
   curl -fsSL https://bun.sh/install | bash
   ```

3. **Figma desktop app** — download from <https://www.figma.com/downloads/>.

4. **Cursor Talk to Figma MCP plugin** — in Figma desktop:
   - Community → search "Cursor Talk to Figma MCP", or
   - Sideload from <https://github.com/sonnylazuardi/cursor-talk-to-figma-mcp>

## Each session

1. Start the socket server locally:
   ```
   bunx cursor-talk-to-figma-mcp --socket
   ```
2. Open Figma desktop → open the `figma-demo` file → run the plugin → note the channel ID.
3. Launch Claude Code in this repo — `.mcp.json` auto-loads the `TalkToFigma` MCP.
4. First message: paste the Figma file URL and channel ID so Claude can connect.

> **Note:** This session also has the official `claude_ai_Figma` MCP available (read-only REST).
> Use `TalkToFigma` for read+write canvas operations; use `claude_ai_Figma` for quick metadata reads.

## Design phase

Ask Claude to create frames, components, and styles. Claude uses MCP tools like
`create_frame`, `create_rectangle`, `create_text`, `set_fill_color`, etc. that write directly
to the open Figma file.

## Implement phase

Ask Claude to implement screen X. Claude uses `get_document_info`, `get_node_info`,
`export_node_as_image` to read the design, then writes Flutter code into `lib/features/<screen>/`.

Feature structure:
```
lib/features/<screen>/
  view.dart          # StatelessWidget / ConsumerWidget
  controller.dart    # Riverpod notifier (if stateful)
```

## Figma file

| Field | Value |
|---|---|
| URL | <https://www.figma.com/design/eAy75avd4oU9y0SyTuJCn5> |
| File key | `eAy75avd4oU9y0SyTuJCn5` |
| Owner | mathmind |
