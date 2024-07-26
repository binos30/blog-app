import globals from "globals";
import pluginJs from "@eslint/js";

export default [
  { languageOptions: { globals: { ...globals.browser, ...globals.node } } },
  pluginJs.configs.recommended,
  {
    ignores: [
      ".cache/",
      ".yarn/",
      "app/assets/builds/*",
      "db/",
      "docs/",
      "lib/",
      "log/*",
      "node_modules/",
      "public/assets/*",
      "spec/",
      "storage/",
      "tmp/",
      "vendor/"
    ]
  }
];
