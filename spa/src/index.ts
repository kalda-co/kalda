import App from "./App.svelte";

declare global {
  interface ImportMeta {
    env: Record<string, string>;
  }
}

function env(name: string): string {
  let value = import.meta.env[name];
  if (value === undefined) {
    throw new Error(`Missing environment variable ${name}`);
  }
  return value;
}

let app = new App({
  target: document.body,
  props: {
    apiBase: env("SNOWPACK_PUBLIC_KALDA_API_BASE"),
  },
});

export default app;
