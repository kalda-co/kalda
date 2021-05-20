<script>
  import type { Title } from "./state";
  import { fly } from "svelte/transition";
  import { link } from "svelte-routing";
  import { deleteApiToken } from "./local-storage";

  export let title: Title;

  let menu = false;

  function toggleMenu() {
    menu = !menu;
  }

  function closeMenu() {
    menu = false;
  }

  function logout(): void {
    deleteApiToken();
  }
</script>

<div class="navbar">
  <a href="/dashboard" class="button-link" use:link on:click={closeMenu}>
    <img
      src="/images/kalda-rainbow-purple-logo.svg"
      alt="Kalda's Rainbow Logo"
      class="logo"
    />
  </a>
  <h1>{title}</h1>
  <button on:click|preventDefault={toggleMenu}>
    <img src="/images/burger-menu.svg" alt="hamburger-menu" class="hamburger" />
  </button>
</div>

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
      <a href="/" on:click={logout} class="button"> Log Out </a>
    </div>
    <button on:click|preventDefault={toggleMenu} class="close-purple">
      <img src="/images/cross-purple.svg" alt="close menu cross" />
    </button>
  </section>
{/if}

<style>
  .navbar {
    padding: var(--gap);
    display: flex;
    flex-direction: row;
    justify-items: center;
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
</style>
