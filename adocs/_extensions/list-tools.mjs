import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";
import makeSynchronous from "make-synchronous";
import { readConfig, invokeInDir } from "ascaid";

const adocConvertSync = makeSynchronous(async (adoc, config, basePath) => {
  const { registerExtensions, adocConvert } = await import("ascaid");
  registerExtensions(config.extensions, basePath);
  return adocConvert(adoc, config.asciidoctorOptions);
});

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const rootDirectory = path.join(__dirname, "../..");
const directoriesToIgnore = [
  ".git",
  ".husky",
  "adocs",
  "docs",
  "node_modules",
  "script",
  "macos",
  "helper-scripts",
];

/**
 * Register an Asciidoctor extension that replaces
 * `list-tools::[]` with a list of tools included in this repo
 */
export const register = async (registry) => {
  const config = await invokeInDir(rootDirectory, () => {
    return readConfig();
  });

  registry.register(function () {
    this.blockMacro("list-tools", async function () {
      this.process((parent, target, attrs) => {
        const tools = fs.readdirSync(rootDirectory).filter((file) => {
          const filePath = path.join(rootDirectory, file);
          const isDirectory = fs.statSync(filePath).isDirectory();
          return isDirectory && !directoriesToIgnore.includes(file);
        });

        // Convert the list of tools to an Asciidoctor list with a link to each tool (from the root of the repo)
        const adoc = tools.map((tool) => `* link:/${tool}[${tool}]`).join("\n");
        const html = adocConvertSync(adoc, config, rootDirectory);

        return this.createPassBlock(parent, html);
      });
    });
  });

  return registry;
};

export default {
  register,
};
