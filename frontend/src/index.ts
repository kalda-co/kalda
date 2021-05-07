import App from "./App.svelte";

declare global {
  interface Window {
    csrfToken: string;
  }
}

const app = new App({
  target: document.body,
  props: {
    csrfToken: window.csrfToken,
  },
});

export default app;
