<script lang="ts">
  import { setCSRFToken, getInitialAppState } from "./backend";
  import Navbar from "./Navbar.svelte";
  import DailyReflection from "./forum/DailyReflection.svelte";
  import Guidelines from "./Guidelines.svelte";
  import Dashboard from "./Dashboard.svelte";

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
    <Navbar navigateTo={(page) => (state.currentPage = page)} />

    {#if state.currentPage === "daily-reflection"}
      <!-- TODO: gracefully handle zero posts -->
      {#each state.posts as post (post.id)}
        <DailyReflection {post} />
      {/each}
    {:else if state.currentPage === "guidelines"}
      <Guidelines />
    {:else}
      <Dashboard
        user={state.currentUser}
        navigateTo={(page) => (state.currentPage = page)}
        post={state.posts[0]}
      />
    {/if}
  </main>
{:catch error}
  <!-- TODO: Error design -->
  failed to load :(
  <div>{error}</div>
{/await}

<!-- TODO: Error design -->
<style>
  main {
    width: 375px;
    max-width: 100%;
    margin: 0 auto;
    background-color: var(--color-white);
    position: relative;
  }
</style>
