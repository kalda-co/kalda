<script>
  import type { Title, AppState } from "./state";
  import type { CommentNotification } from "./state";
  import { fly } from "svelte/transition";
  import { link } from "svelte-routing";
  import { deleteApiToken } from "./local-storage";
  import { cancelDailyReflectionNotifications } from "./local-notification";

  export let state: AppState;
  export let title: Title;
  export let notifications: CommentNotification[];

  let menu = false;

  function toggleMenu() {
    menu = !menu;
  }

  function closeMenu() {
    menu = false;
  }

  function logout(): void {
    cancelDailyReflectionNotifications();
    deleteApiToken();
  }
</script>

<div class="navbar">
  <div class="left-links">
    <a href="/dashboard" class="button-link" use:link on:click={closeMenu}>
      <img
        src="/images/kalda-rainbow-logo.svg"
        alt="Kalda's Rainbow Logo"
        class="logo"
      />
    </a>
    {#if title == "Kalda"}
      <a use:link href="/notifications" on:click={closeMenu}>
        <button class="alert-button">
          {#if !notifications.length}
            <img
              src="/images/unalert.svg"
              alt="Bell for notifications"
              class="alert-image"
            />
          {:else}
            <img
              src="/images/alert.svg"
              alt="Bell for notifications"
              class="alert-image"
            />
          {/if}
          <span>Alerts</span>
        </button>
      </a>
    {/if}
  </div>
  {#if title == "Kalda"}
    <h1 class="title-hidden">{title}</h1>
  {:else}
    <h1 class="title">{title}</h1>
  {/if}
  <button on:click|preventDefault={toggleMenu}>
    <img src="/images/burger-menu.svg" alt="hamburger-menu" class="hamburger" />
  </button>
</div>
{#if state.currentUser.hasSubscription == false}
  <div class="banner">
    <a use:link href="/subscription">
      <div class="button-content">
        <div class="subscription-button">
          <img
            class="inline-icon banner-image"
            src="/images/loudhailer.svg"
            alt="loud hailer icon"
          />
          PREMIUM OFFER £2.99 a month
        </div>
      </div>
    </a>
  </div>
{/if}

{#if menu}
  <section class="sidebar" transition:fly={{ y: 200, duration: 400 }}>
    <button on:click|preventDefault={toggleMenu} class="close">
      <img src="/images/cross.svg" alt="close menu cross" />
    </button>

    <div class="content button-grid">
      <a use:link href="/dashboard" on:click={closeMenu} class="button">
        Dashboard
      </a>
      <a use:link href="/guidelines" on:click={closeMenu} class="button">
        Guidelines
      </a>
      <a use:link href="/daily-reflection" on:click={closeMenu} class="button">
        Daily Reflection
      </a>
      <a use:link href="/therapy-sessions" on:click={closeMenu} class="button">
        Group Sessions
      </a>
      <a use:link href="/urgent-support" on:click={closeMenu} class="button">
        Urgent Support
      </a>
      <a use:link href="/subscription" on:click={closeMenu} class="button">
        Subscription
      </a>
      <a use:link href="/notifications" on:click={closeMenu} class="button">
        Notifications
      </a>
      <a href="/" on:click={logout} class="button"> Log Out </a>
    </div>
    <a use:link href="/nerd-data" on:click={closeMenu} class="debug-button">
      <img src="/images/cross-purple.svg" alt="close menu cross" />
    </a>
  </section>
{/if}

<style>
  .navbar {
    background-color: var(--color-purple);
    padding: var(--gap);
    display: flex;
    flex-direction: row;
    justify-items: center;
  }
  .left-links {
    display: flex;
    flex-direction: row;
  }
  .logo {
    margin-top: 2px;
  }
  button.alert-button {
    border: solid white 1px;
    border-radius: 90px;
    padding-left: var(--gap-s);
    padding-right: var(--gap-s);
    margin-left: var(--gap);
    color: var(--color-white);
  }
  button > img,
  button > span {
    vertical-align: middle;
  }
  button > span {
    padding-left: 4px;
  }
  .alert-image {
    padding-top: 5px;
    padding-bottom: 5px;
  }
  .title-hidden {
    color: var(--color-purple);
  }
  .title {
    color: var(--color-white);
  }

  h1 {
    flex-grow: 10;
    margin: 0;
    text-align: center;
    color: var(--color-purple);
    font-size: 1rem;
  }

  .logo,
  .hamburger {
    --size: 29px;
    width: var(--size);
    height: var(--size);
  }

  .sidebar {
    color: var(--color-white);
    width: 100%;
    position: fixed;
    top: 0;
    height: 100vh;
    background-color: var(--color-purple);
    z-index: 1000;

    display: flex;
    justify-content: space-between;
    flex-direction: column;
  }

  .button-grid {
    display: flex;
    justify-content: space-around;
    flex-wrap: wrap;
    max-width: 500px;
  }

  .button {
    background-color: var(--color-white);
    color: var(--color-purple);
    margin: var(--gap-s);
    padding: var(--gap) 28px;
  }
  .close {
    margin: var(--gap-s) var(--gap);
    text-align: right;
  }

  .debug-button {
    margin: 0;
    display: inline-block;
    width: min-content;
  }
  .banner-image {
    height: 19px;
    margin-right: 0px;
    margin-bottom: -5px;
  }

  .banner {
    background-color: var(--color-purple);
    padding-bottom: 8px;
  }

  .button-content {
    width: 100%;
    max-width: var(--full-width);
    padding-left: var(--gap);
    padding-right: var(--gap);
    margin-left: auto;
    margin-right: auto;
  }

  .subscription-button {
    max-width: calc(var(--full-width) - var(--gap-l));
    margin-left: auto;
    margin-right: auto;
    background-color: #8bffde;
    border: solid 1px #8bffde;
    padding-top: 10px;
    padding-bottom: 10px;
    border-radius: 20px;
    font-weight: 500;
    color: #404040;
    font-size: 16px;
    display: block;
    text-align: center;
  }
</style>
