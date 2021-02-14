<script lang="ts">
  import { setCSRFToken, getInitialAppState } from "./backend";
  import Navbar from "./Navbar.svelte";
  import DailyReflection from "./forum/DailyReflection.svelte";

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
  <main>
    <Navbar />
    <!-- TODO: gracefully handle zero posts -->
    <DailyReflection post={state.posts[0]} />
  </main>
{:catch error}
  <!-- TODO: Error design -->
  failed to load :(
  {error}
{/await}

<!-- TODO: Error design -->
<style>
  main {
    width: 375px;
    max-width: 100%;
    margin: 0 auto;
    background-color: var(--color-white);
  }
</style>
