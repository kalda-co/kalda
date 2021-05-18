<script lang="ts">
  import Authenticated from "./Authenticated.svelte";
  import type { ApiClient } from "./backend";
  import { AuthenticatedApiClient } from "./backend";

  export let csrfToken: string | undefined;
</script>

<!-- If we have a csrfToken we must be logged in -->
{#if csrfToken}
  <Authenticated api={new AuthenticatedApiClient(csrfToken)} />
{:else}
  Not logged in
{/if}
