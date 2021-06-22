<script lang="ts">
  import type { ApiClient } from "./backend";
  import { alertbox } from "./dialog";
  import Loaded from "./Loaded.svelte";
  import { onDestroy } from "svelte";
  import { MINUTE } from "./constants";
  import {
    currentNetworkConnectionStatus,
    whenAppForegrounded,
  } from "./device";

  export let api: ApiClient;

  let appState = api.getInitialAppState();
  let stateLastRefreshedAt = new Date();

  async function refreshStateIfStale() {
    let status = await currentNetworkConnectionStatus();
    if (status === "wifi" || (status === "cellular" && enoughTimeElapsed())) {
      refreshAppState();
    }
  }

  async function refreshAppState() {
    let newState = await api.getInitialAppState();
    appState = Promise.resolve(newState);
  }

  function enoughTimeElapsed(): boolean {
    let now = new Date().getTime();
    let cacheInvalidationTime = stateLastRefreshedAt.getTime() + 5 * MINUTE;
    return now > cacheInvalidationTime;
  }

  // Add an event listener so that the appState can be refreshed from the
  // backend when the user returns to the app, assuming that enough time has
  // passed since the previous loading of the state.
  let foregroundListenerHandle = whenAppForegrounded(refreshStateIfStale);
  onDestroy(() => foregroundListenerHandle.cancel());

  let state = api.getInitialAppState();

  // When there is an uncaught exception we show a message to the user to let
  // them know there is a problem and reload the application. Hopefully that
  // fixes the problem.
  // This should never happen, if it does it means we have a bug.
  window.onunhandledrejection = async (error: any) => {
    window.Rollbar.error(error);
    console.error(error);
    await alertbox(
      "Oh no! Something went wrong!",
      "Sorry, an unexpected error occurred. Please try again later and contact us if it happens again."
    );
    window.location.pathname = "/dashboard";
  };
</script>

{#await state}
  <!-- TODO: Loading design -->
  ... Loading
{:then response}
  {#if response.type === "Success"}
    <Loaded state={response.resource} {api} />
  {:else}
    <!-- TODO: Error design -->
    failed to load :(
    <div>{response.detail}</div>
  {/if}
{:catch error}
  <!-- TODO: Error design -->
  failed to load :(
  <div>{error}</div>
{/await}
