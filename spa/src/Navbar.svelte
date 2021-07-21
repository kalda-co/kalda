<script>
  import type { Title, User, AppState } from "./state";
  import { fly } from "svelte/transition";
  import { link } from "svelte-routing";
  import { deleteApiToken } from "./local-storage";
  import { cancelDailyReflectionNotifications } from "./local-notification";

  export let currentUser: User;
  export let state: AppState;
  export let title: Title;

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
  <a href="/dashboard" class="button-link" use:link on:click={closeMenu}>
    <img
      src="/images/kalda-rainbow-logo.svg"
      alt="Kalda's Rainbow Logo"
      class="logo"
    />
  </a>
  <h1 class="title">{title}</h1>
  <button on:click|preventDefault={toggleMenu}>
    <img src="/images/burger-menu.svg" alt="hamburger-menu" class="hamburger" />
  </button>
</div>
{#if currentUser.hasSubscription == false}
  <div class="banner">
    <a use:link href="/subscription">
      <div class="subscription-button">
        <img
          class="inline-icon banner-image"
          src="images/loudhailer.svg"
          alt="loud hailer icon"
        />
        PREMIUM OFFER £2.99 a month
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
        Home
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
      <a use:link href="/will-pool" on:click={closeMenu} class="button">
        Will Pool
      </a>
      <a use:link href="/subscription" on:click={closeMenu} class="button">
        Subscription
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
    margin: var(--gap);
    padding: var(--gap) var(--gap-l);
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

  .subscription-button {
    background-color: #8bffde;
    border: solid 1px #8bffde;
    padding: 10px 24px;
    margin: 0px 16px;
    border-radius: 20px;
    font-weight: 500;
    color: #404040;
    font-size: 16px;
    display: block;
    text-align: center;
  }
</style>
