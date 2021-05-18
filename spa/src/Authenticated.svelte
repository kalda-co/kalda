<script lang="ts">
  import type { ApiClient } from "./backend";
  import { AuthenticatedApiClient } from "./backend";
  import Loaded from "./Loaded.svelte";

  export let api: ApiClient;
</script>

{#await api.getInitialAppState()}
  <!-- TODO: Loading design -->
  ... Loading
{:then state}
  <Loaded {state} {api} />
{:catch error}
  <!-- TODO: Error design -->
  failed to load :(
  <div>{error}</div>
{/await}
