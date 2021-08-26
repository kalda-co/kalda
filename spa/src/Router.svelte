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
  import type { AppState, Post } from "./state";
  import type { ApiClient, Response } from "./backend";
  import {
    scheduleDailyReflectionNotifications,
    scheduleTherapyNotifications,
  } from "./local-notification";

  export let state: AppState;
  export let api: ApiClient;
  export let stripe: Promise<Stripe>;

  scheduleDailyReflectionNotifications();
  scheduleTherapyNotifications(state.therapies);

  async function getPostById(
    state: AppState,
    paramId: string
  ): Promise<Post | undefined> {
    let id: number = parseInt(paramId);
    // Look for the post in the daily reflections
    let foundPost = state.reflections.find((post) => post.id == id);
    if (foundPost) return foundPost;

    // We don't have this post yet so get it from the API
    let response = await api.getPostState(id);
    if (response.type === "Success") return response.resource;
  }
</script>

<main>
  <Router>
    <Route path="daily-reflection">
      <Navbar
        notifications={state.commentNotifications}
        title="Daily Reflection"
        {state}
      />
      {#each state.reflections as post (post.id)}
        <Thread
          placeholder="Your reflection here"
          commentName="response"
          {api}
          {post}
          {state}
        />
      {/each}
    </Route>

    <Route path="will-pool">
      <Navbar
        notifications={state.commentNotifications}
        title="Will Pool"
        {state}
      />
      {#each state.pools as post (post.id)}
        <Thread
          placeholder="Your commitment here"
          commentName="commitment"
          {api}
          {post}
          {state}
        />
      {/each}
    </Route>

    <Route path="guidelines">
      <Navbar
        notifications={state.commentNotifications}
        title="Guidelines"
        {state}
      />
      <Guidelines />
    </Route>

    <Route path="group-info">
      <Navbar
        notifications={state.commentNotifications}
        title="Session Info"
        {state}
      />
      <GroupSessions />
    </Route>

    <Route path="therapy-sessions">
      <Navbar
        notifications={state.commentNotifications}
        title="Therapy Sessions"
        {state}
      />
      <TherapySessions therapies={state.therapies} />
    </Route>

    <Route path="urgent-support">
      <Navbar
        notifications={state.commentNotifications}
        title="Urgent Support"
        {state}
      />
      <UrgentSupport />
    </Route>

    <Route path="nerd-data">
      <Navbar
        notifications={state.commentNotifications}
        title="Nerd data"
        {state}
      />
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
    </Route>

    <Route path="notifications">
      <Navbar
        notifications={state.commentNotifications}
        title="Notifications"
        {state}
      />
      <Notifications notifications={state.commentNotifications} />
    </Route>

    <Route path="posts/:id" let:params>
      <Navbar
        notifications={state.commentNotifications}
        title="Notification"
        {state}
      />
      {#await getPostById(state, params.id)}
        <Loading />
      {:then post}
        {#if post}
          <Thread
            placeholder="Your reflection here"
            commentName="response"
            {api}
            {post}
            {state}
          />
        {:else}
          Post not found
        {/if}
      {/await}
    </Route>

    <!-- Default catch all route -->
    <Route>
      <Navbar
        notifications={state.commentNotifications}
        title="Kalda"
        {state}
      />
      <Dashboard
        user={state.currentUser}
        post={state.reflections[0]}
        therapy={state.nextTherapy}
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
