<script lang="ts">
  import { getInitialAppState } from "./backend";

  import Navbar from "./Navbar.svelte";
  import DailyReflection from "./forum/DailyReflection.svelte";
  import type { AppState, User, Post } from "./state";

  let state: AppState = { type: "loading" };
  (async () => {
    state = await getInitialAppState();
  })();
</script>

<!-- TODO: Loading design -->
{#if state.type === "loading"}
  ... Loading
{/if}

<!-- TODO: Error design -->
{#if state.type === "failed_to_load"}
  failed to load :(
  {state.error}
{/if}

{#if state.type === "loaded"}
  <main>
    <Navbar />
    <!-- TODO: gracefully handle zero posts -->
    <DailyReflection post={state.posts[0]} currentUser={state.current_user} />
  </main>
{/if}

<!-- TODO: Error design -->
<style>
  main {
    width: 375px;
    max-width: 100%;
    margin: 0 auto;
    background-color: var(--color-white);
  }
</style>
