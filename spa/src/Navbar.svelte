<script>
  import type { Page, Title } from "./state";
  import { fly } from "svelte/transition";
  import { getCSRFToken } from "./backend";

  export let navigateTo: (page: Page) => any;
  export let title: Title;

  let menu = false;

  function toggleMenu() {
    menu = !menu;
  }

  function go(page: Page) {
    return () => {
      menu = false;
      navigateTo(page);
    };
  }
</script>

<div class="navbar">
  <button class="button-link" on:click|preventDefault={go("dashboard")}>
    <img
      src="/images/kalda-rainbow-purple-logo.svg"
      alt="Kalda's Rainbow Logo"
      class="logo"
    />
  </button>
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

    <div class="button-grid">
      <!-- <button class="button"> Urgent Support </button> -->
      <button on:click|preventDefault={go("dashboard")} class="button">
        Home
      </button>
      <button on:click|preventDefault={go("guidelines")} class="button">
        Guidelines
      </button>
      <button on:click|preventDefault={go("daily-reflection")} class="button">
        Daily Reflection
      </button>
      <button on:click|preventDefault={go("group-therapy-info")} class="button">
        Group Therapy
      </button>
      <button on:click|preventDefault={go("therapy-sessions")} class="button">
        Therapy Sessions
      </button>
      <button on:click|preventDefault={go("urgent-support")} class="button">
        Urgent Support
      </button>
      <button on:click|preventDefault={go("will-pool")} class="button">
        Will Pool
      </button>
      <form method="POST" action="/users/log-out">
        <input type="hidden" name="_csrf_token" value={getCSRFToken()} />
        <input type="hidden" name="_method" value="delete" />
        <button type="submit" class="button">Log Out</button>
      </form>
    </div>

    <button on:click|preventDefault={toggleMenu} class="close">
      <img src="/images/cross.svg" alt="close menu cross" />
    </button>
  </section>
{/if}

<style>
  .button-link {
    border: unset;
    padding: unset;
    font-weight: unset;
  }

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
    width: var(--sidebar-width);
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
    width: 375px;
    display: flex;
    justify-content: space-around;
    flex-wrap: wrap;
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
