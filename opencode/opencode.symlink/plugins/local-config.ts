import type { Plugin } from "@opencode-ai/plugin";
import { access, constants, readFile, writeFile } from "node:fs/promises";
import { homedir } from "node:os";
import { join } from "node:path";

type JsonObject = Record<string, unknown>;

function isObject(value: unknown): value is JsonObject {
	if (value === null) return false;
	if (typeof value !== "object") return false;
	if (Array.isArray(value)) return false;
	return true;
}

/**
 * Recursively merge `from` into `into`. Nested objects are merged;
 * arrays and primitives are overwritten.
 */
function deepMerge(into: JsonObject, from: JsonObject): void {
	for (const [key, sourceValue] of Object.entries(from)) {
		const targetValue = into[key];

		if (isObject(sourceValue) && isObject(targetValue)) {
			deepMerge(targetValue, sourceValue);
		} else {
			into[key] = sourceValue;
		}
	}
}

export const LocalConfigPlugin: Plugin = async () => {
	const filePath = join(
		homedir(),
		".config",
		"opencode",
		"local-opencode.json",
	);

	const fileExists = await access(filePath, constants.F_OK)
		.then(() => true)
		.catch(() => false);

	if (!fileExists) {
    const skeleton = { "$schema": "https://opencode.ai/config.json" };
		await writeFile(filePath, JSON.stringify(skeleton, null, 2), "utf-8");
		return {};
	}

	let localConfig: unknown;
	try {
		const raw = await readFile(filePath, "utf-8");
		localConfig = JSON.parse(raw);
	} catch {
		return {};
	}

	if (!isObject(localConfig)) {
		return {};
	}

	// Return the `config` hook so OpenCode calls it with the live merged config.
	return {
		config(cfg) {
			deepMerge(cfg as JsonObject, localConfig as JsonObject);
		},
	};
};
