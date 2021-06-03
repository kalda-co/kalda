import App from "./App.svelte";

let apiBase: string = document.body.dataset.apiBase || "";

let app = new App({
  target: document.body,
  props: { apiBase },
});

export default app;
