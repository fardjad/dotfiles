import type { Plugin } from "@opencode-ai/plugin";
import { parse } from "dotenv";
import { readFile } from "node:fs/promises";
import { join } from "node:path";

export const ProjectOpenrouterKeyPlugin: Plugin = async ({ directory }) => {
  const envPath = join(directory, ".env");

  let fileKey: string | undefined;
  try {
    const text = await readFile(envPath, "utf-8");
    fileKey = parse(text).OPENROUTER_API_KEY;
  } catch {
    // .env missing or unreadable — skip
  }

  // Environment wins over .env
  const resolvedKey = process.env.OPENROUTER_API_KEY ?? fileKey;

  if (!resolvedKey) {
    return {};
  }

  return {
    async config(cfg) {
      const config = cfg as Record<string, unknown>;
      const providers = (config.provider ??= {}) as Record<string, unknown>;
      const openrouter = (providers.openrouter ??= {}) as Record<string, unknown>;
      const options = (openrouter.options ??= {}) as Record<string, unknown>;
      options.apiKey = resolvedKey;
    },
  };
};
