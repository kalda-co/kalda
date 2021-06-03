let browser = "browser";

/** @type {import("snowpack").SnowpackUserConfig } */
module.exports = {
  mount: {
    "spa/static": { url: "/", static: true },
    "assets/static": { url: "/", static: true },
    "spa/src": { url: "/src" },
  },
  plugins: ["@snowpack/plugin-svelte", "@snowpack/plugin-typescript"],
  routes: [
    /* Enable an SPA Fallback in development: */
    // {"match": "routes", "src": ".*", "dest": "/index.html"},
  ],
  optimize: {
    bundle: true,
    entrypoints: ["spa/src/index.ts"],
  },
  packageOptions: {
    /* ... */
  },
  devOptions: {
    output: "stream",
    open: "none",
    port: 4451,
    hmrPort: 4452,
  },
  buildOptions: {
    out: "priv/static",
  },
};
