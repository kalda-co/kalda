<script lang="ts">
  import type { ApiClient } from "./backend";
  import type { Stripe } from "@stripe/stripe-js";
  import { alertbox } from "./dialog";
  import Router from "./Router.svelte";
  import Loading from "./Loading.svelte";
  import { onDestroy } from "svelte";
  import { MINUTE } from "./constants";
  import {
    currentNetworkConnectionStatus,
    whenAppForegrounded,
  } from "./device";
  import * as log from "./log";
  import { UnmatchedError } from "./exhaustive";

  export let api: ApiClient;
  export let stripe: Promise<Stripe>;

  let appState = api.getInitialAppState();
  let stateLastRefreshedAt = new Date();

  async function refreshStateIfStale() {
    let status = await currentNetworkConnectionStatus();
    switch (status) {
      case "wifi":
        log.info("On wifi, reloading state");
        refreshAppState();
        break;

      case "cellular":
        if (enoughTimeElapsed()) {
          log.info("On cellular with stale data, reloading state");
          refreshAppState();
        } else {
          log.info("On cellular with fresh data, not reloading state");
        }
        break;

      case "none":
        log.info("No network connection. Not reloading state.");
        break;

      default:
        throw new UnmatchedError(status);
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
    try {
      log.error(error);
      window.Rollbar.error(error);
      await alertbox(
        "Oh no! Something went wrong!",
        "Sorry, an unexpected error occurred. Please try again later and contact us if it happens again."
      );
    } catch (error) {
      console.error(error);
    }
    setTimeout(() => {
      window.location.pathname = "/dashboard";
    }, 250);
  };
</script>

{#await state}
  <Loading />
{:then response}
  {#if response.type === "Success"}
    <Router state={response.resource} {api} {stripe} />
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
