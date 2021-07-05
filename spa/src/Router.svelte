<script lang="ts">
  import Navbar from "./Navbar.svelte";
  import Thread from "./forum/Thread.svelte";
  import NerdData from "./NerdData.svelte";
  import Loading from "./Loading.svelte";
  import Guidelines from "./Guidelines.svelte";
  import GroupSessions from "./SessionInfo.svelte";
  import Dashboard from "./Dashboard.svelte";
  import TherapySessions from "./GroupSessions.svelte";
  import UrgentSupport from "./UrgentSupport.svelte";
  import Subscription from "./Subscription/Subscription.svelte";
  import MyAccount from "./Subscription/MyAccount.svelte";
  import Notifications from "./Notifications.svelte";
  import { Router, Route } from "svelte-routing";
  import type { Stripe } from "./stripe";
  import type { AppState } from "./state";
  import type { ApiClient } from "./backend";
  import {
    scheduleDailyReflectionNotifications,
    scheduleTherapyNotifications,
  } from "./local-notification";

  export let state: AppState;
  export let api: ApiClient;
  export let stripe: Promise<Stripe>;

  scheduleDailyReflectionNotifications();
  scheduleTherapyNotifications(state.therapies);
</script>

<main>
  <Router>
    <Route path="daily-reflection">
      <Navbar title="Daily Reflection" {state} />
      {#each state.reflections as post (post.id)}
        <Thread
          placeholder="Your reflection here"
          commentName="response"
          currentUser={state.currentUser}
          {api}
          {post}
          {state}
        />
      {/each}
    </Route>

    <Route path="will-pool">
      <Navbar title="Will Pool" {state} />
      {#each state.pools as post (post.id)}
        <Thread
          placeholder="Your commitment here"
          commentName="commitment"
          currentUser={state.currentUser}
          {api}
          {post}
          {state}
        />
      {/each}
    </Route>

    <Route path="guidelines">
      <Navbar title="Guidelines" {state} />
      <Guidelines />
    </Route>

    <Route path="group-info">
      <Navbar title="Session Info" {state} />
      <GroupSessions />
    </Route>

    <Route path="therapy-sessions">
      <Navbar title="Therapy Sessions" {state} />
      <TherapySessions
        therapies={state.therapies}
        currentUser={state.currentUser}
      />
    </Route>

    <Route path="urgent-support">
      <Navbar title="Urgent Support" {state} />
      <UrgentSupport />
    </Route>

    <Route path="nerd-data">
      <Navbar title="Nerd data" {state} />
      <NerdData />
    </Route>

    <Route path="subscription">
      {#if state.currentUser.hasSubscription}
        <MyAccount />
        <!-- TODO: Date subscription ends -->
        <!-- TODO: Cancel button -->
      {:else}
        {#await stripe}
          <Loading />
        {:then stripe}
          <Subscription {stripe} {api} />
        {/await}
      {/if}
      
    <Route path="notifications">
      <Navbar title="Notifications" />
      <Notifications notifications={state.commentNotifications} />
    </Route>

    <!-- Default catch all route -->
    <Route>
      <Navbar title="Kalda" {state} />
      <Dashboard
        user={state.currentUser}
        post={state.reflections[0]}
        therapy={state.next_therapy}
      />
    </Route>

    <!-- TODO: route not found page -->
  </Router>
</main>

<style>
  main {
    margin: 0 auto;
    position: relative;
  }
</style>
