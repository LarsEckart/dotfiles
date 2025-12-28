import { spawn } from "node:child_process";
import type { HookAPI } from "@mariozechner/pi-coding-agent/hooks";

/**
 * Plays a sound when the agent completes a task.
 * Uses macOS system sounds (Submarine.aiff) like Amp does.
 */
export default function (pi: HookAPI) {
  pi.on("agent_end", async () => {
    if (process.platform !== "darwin") return;

    // Play async, don't wait - we don't want to delay the agent
    spawn("afplay", ["/System/Library/Sounds/Submarine.aiff"], {
      stdio: "ignore",
      detached: true,
    }).unref();
  });
}
