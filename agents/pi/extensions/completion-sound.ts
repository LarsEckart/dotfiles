import { spawn } from "node:child_process";
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

/**
 * Plays a sound when the agent completes a task.
 * Uses macOS system sounds (Submarine.aiff) like Amp does.
 */
export default function (pi: ExtensionAPI) {
  pi.on("agent_end", async () => {
    if (process.platform !== "darwin") return;

    // Play async, don't wait - we don't want to delay the agent
    spawn("afplay", ["/System/Library/Sounds/Submarine.aiff"], {
      stdio: "ignore",
      detached: true,
    }).unref();
  });
}
