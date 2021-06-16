<script lang="ts">
  import Loaded from "./Loaded.svelte";
  import { onDestroy } from "svelte";
  import type { ApiClient } from "./backend";
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
</script>

{#await appState}
  <!-- TODO: Loading design -->
  ... Loading
{:then state}
  <Loaded {state} {api} />
{:catch error}
  <!-- TODO: Error design -->
  failed to load :(
  <div>{error}</div>
{/await}
