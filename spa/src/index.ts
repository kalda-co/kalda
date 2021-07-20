import App from "./App.svelte";
import Rollbar from "rollbar";

declare global {
  interface Window {
    Rollbar: Rollbar;
  }
}

let apiBase: string = document.body.dataset.apiBase || "";
let environment: string = document.body.dataset.environment || "unknown";
let stripePublishableKey: string =
  document.body.dataset.stripePublishableKey || "bad-key";

window.Rollbar = new Rollbar({
  accessToken: "5bf70821e7bb4dbc8c77e91549809bee",
  captureUncaught: true,
  captureUnhandledRejections: true,
  environment,
  enabled: environment !== "dev",
});

let app = new App({
  target: document.body,
  props: { apiBase, stripePublishableKey },
});

export default app;
