<script lang="ts">
  import { setCSRFToken, getInitialAppState } from "./backend";
  import Loaded from "./Loaded.svelte";

  // Load the CSRF token into the backend API client module so we can make HTTP
  // requests using cookie auth
  export let csrfToken: string;
  setCSRFToken(csrfToken);

  let state = getInitialAppState();
</script>

{#await state}
  <!-- TODO: Loading design -->
  ... Loading
{:then state}
  <Loaded {state} />
{:catch error}
  <!-- TODO: Error design -->
  failed to load :(
  <div>{error}</div>
{/await}
