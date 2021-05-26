let browser = "browser";

let environments = {
  mobile: {
    out: "mobile/www",
    apiBase: "https://kalda.co",
  },
  browser: {
    out: "priv/static/",
    apiBase: "",
  },
};

let environment = environments[process.env.KALDA_TARGET || browser];

// Set environment variables to be included in the JavaScript bundle under
// the `import.meta.env` object
process.env.SNOWPACK_PUBLIC_KALDA_API_BASE = environment.apiBase;

/** @type {import("snowpack").SnowpackUserConfig } */
module.exports = {
  mount: {
    "spa/static": { url: "/", static: true },
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
    out: environment.out,
  },
};
