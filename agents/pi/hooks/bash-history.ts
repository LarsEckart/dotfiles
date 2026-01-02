import * as fs from "node:fs";
import * as os from "node:os";
import * as path from "node:path";
import type { HookAPI } from "@mariozechner/pi-coding-agent/hooks";

/**
 * Adds bash tool calls to your shell history so you can recall them
 * with arrow keys or Ctrl+R in your terminal.
 */
export default function (pi: HookAPI) {
  // Support both ZSH and Bash history files
  const histFile = process.env.HISTFILE 
    ?? path.join(os.homedir(), ".zsh_history");
  
  const isZsh = histFile.includes("zsh");

  pi.on("tool_result", async (event, ctx) => {
    // Check tool name directly - isBashToolResult isn't properly exported from the package
    if (event.toolName !== "bash") return;
    if (event.isError) return; // Skip failed commands

    const command = event.input.command as string;
    if (!command?.trim()) return;

    try {
      // ZSH extended history format: `: timestamp:0;command`
      // Bash format: just the command
      // Prefix with "# pi: " comment so agent commands are identifiable
      // Escape newlines so multi-line commands don't break history format
      const timestamp = Math.floor(Date.now() / 1000);
      const escapedCommand = command.replace(/\n/g, '\\n');
      const prefixedCommand = `# pi: ${escapedCommand}`;
      const entry = isZsh 
        ? `: ${timestamp}:0;${prefixedCommand}\n`
        : `${prefixedCommand}\n`;

      fs.appendFileSync(histFile, entry);
    } catch (err) {
      // Silently fail - don't interrupt the agent
      ctx.ui.notify(`Failed to add to history: ${err}`, "warning");
    }
  });
}
