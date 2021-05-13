<script lang="ts">
  import Navbar from "./Navbar.svelte";
  import Thread from "./forum/Thread.svelte";
  import Guidelines from "./Guidelines.svelte";
  import GroupSessions from "./SessionInfo.svelte";
  import Dashboard from "./Dashboard.svelte";
  import TherapySessions from "./GroupSessions.svelte";
  import UrgentSupport from "./UrgentSupport.svelte";
  import { Router, Route } from "svelte-routing";
  import type { AppState } from "./state";

  export let state: AppState;
</script>

<main>
  <Router>
    <Route path="daily-reflection">
      <Navbar title="Daily Reflection" />
      <!-- TODO: gracefully handle zero posts -->
      {#each state.reflections as post (post.id)}
        <Thread
          placeholder="Your reflection here"
          commentName="responses"
          currentUser={state.currentUser}
          {post}
        />
      {/each}
    </Route>

    <Route path="will-pool">
      <Navbar title="Will Pool" />
      {#each state.pools as post (post.id)}
        <Thread
          placeholder="Your commitment here"
          commentName="commitment"
          currentUser={state.currentUser}
          {post}
        />
      {/each}
    </Route>

    <Route path="guidelines">
      <Navbar title="Guidelines" />
      <Guidelines />
    </Route>

    <Route path="group-info">
      <Navbar title="Session Info" />
      <GroupSessions />
    </Route>

    <Route path="therapy-sessions">
      <Navbar title="Therapy Sessions" />
      <TherapySessions therapies={state.therapies} />
    </Route>

    <Route path="urgent-support">
      <Navbar title="Urgent Support" />
      <UrgentSupport />
    </Route>

    <!-- Default catch all route -->
    <Route>
      <Navbar title="Kalda" />
      <Dashboard
        user={state.currentUser}
        post={state.reflections[0]}
        therapy={state.next_therapy}
        pool={state.pools[0]}
      />
    </Route>

    <!-- TODO: route not found page -->
  </Router>
</main>

<!-- TODO: Error design -->
<style>
  main {
    margin: 0 auto;
    position: relative;
  }
</style>
