/** @type {import("snowpack").SnowpackUserConfig } */
module.exports = {
  mount: {
    static: { url: "/", static: true },
    src: { url: "/src" },
  },
  plugins: [
    "@snowpack/plugin-svelte",
    "@snowpack/plugin-dotenv",
    "@snowpack/plugin-typescript",
  ],
  routes: [
    /* Enable an SPA Fallback in development: */
    // {"match": "routes", "src": ".*", "dest": "/index.html"},
  ],
  optimize: {
    /* Example: Bundle your final build: */
    bundle: true,
    entrypoints: ["src/index.ts"],
  },
  packageOptions: {
    /* ... */
  },
  devOptions: {
    output: "stream",
  },
  buildOptions: {
    out: "../priv/static/spa/",
  },
};
