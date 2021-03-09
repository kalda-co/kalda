<script lang="ts">
  import Navbar from "./Navbar.svelte";
  import Thread from "./forum/Thread.svelte";
  import Guidelines from "./Guidelines.svelte";
  import GroupTherapy from "./GroupTherapy.svelte";
  import Dashboard from "./Dashboard.svelte";
  import TherapySessions from "./TherapySessions.svelte";
  import UrgentSupport from "./UrgentSupport.svelte";
  import type { Page, AppState } from "./state";

  export let state: AppState;

  function navigateTo(page: Page) {
    state.currentPage = page;
  }
</script>

<main>
  {#if state.currentPage === "daily-reflection"}
    <Navbar {navigateTo} title="Daily Reflection" />

    <!-- TODO: gracefully handle zero posts -->
    {#each state.reflections as post (post.id)}
      <Thread
        placeholder="Your reflection here"
        commentName="reflection"
        {post}
      />
    {/each}
  {:else if state.currentPage === "will-pool"}
    <Navbar {navigateTo} title="Will Pool" />
    {#each state.pools as post (post.id)}
      <Thread
        placeholder="Your commitment here"
        commentName="commitment"
        {post}
      />
    {/each}
  {:else if state.currentPage === "guidelines"}
    <Navbar {navigateTo} title="Guidelines" />
    <Guidelines />
  {:else if state.currentPage === "group-therapy-info"}
    <Navbar {navigateTo} title="Group Therapy" />
    <GroupTherapy />
  {:else if state.currentPage === "therapy-sessions"}
    <Navbar {navigateTo} title="Therapy Sessions" />
    <TherapySessions therapies={state.therapies} {navigateTo} />
  {:else if state.currentPage === "urgent-support"}
    <Navbar {navigateTo} title="Urgent Support" />
    <UrgentSupport />
  {:else}
    <Navbar {navigateTo} title="Kalda" />
    <Dashboard
      user={state.currentUser}
      post={state.reflections[0]}
      therapy={state.next_therapy}
      pool={state.pools[0]}
      {navigateTo}
    />
  {/if}
</main>

<!-- TODO: Error design -->
<style>
  main {
    margin: 0 auto;
    position: relative;
  }
</style>
