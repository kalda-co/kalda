<script>
  let menu = false;

  function toggleMenu() {
    menu = !menu;
  }
  import { fly } from "svelte/transition";
</script>

<nav class="nav-container">
  <div class="navtop">
    <div class="navbar">
      <a href="/app">
        <img
          src="/images/kalda-rainbow-purple-logo.svg"
          alt="Kalda's Rainbow Logo"
          class="logo"
        />
      </a>
      <h1>Daily reflection</h1>
      <button on:click|preventDefault={toggleMenu}>
        <img
          src="/images/burger-menu.svg"
          alt="hamburger-menu"
          class="hamburger"
        />
      </button>
    </div>
  </div>

  <div class="sidebar">
    <div transition:fly|local class:menu>
      {#if menu}
        <section transition:fly={{ y: 200, duration: 1000 }}>
          <button on:click|preventDefault={toggleMenu}>
            <img
              src="/images/cross.svg"
              alt="close menu cross"
              class="cross-top"
            />
          </button>
          <div class="button-container">
            <div class="button-grid">
              <a href="/app">
                <button class="button"> Home </button>
              </a>
              <a href="/app">
                <button class="button"> Group Therapy </button>
              </a>
              <a href="/app">
                <button class="button"> Community </button>
              </a>
              <a href="/app">
                <button class="button"> Urgent Support </button>
              </a>
              <a href="/app">
                <button class="button"> Log Out </button>
              </a>
            </div>
          </div>
          <button on:click|preventDefault={toggleMenu}>
            <img src="/images/cross.svg" alt="close menu cross" class="cross" />
          </button>
        </section>
      {/if}
    </div>
  </div>
</nav>

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
    overflow: hidden;
  }
  .nav-container {
    display: flex;
    flex-direction: row-reverse;
  }

  .navtop {
    top: 0;
    background-color: transparent;
    width: 375px;
    max-width: 100%;
    z-index: 2;
  }

  .sidebar {
    color: var(--color-white);
    display: inline-block;
    width: var(--sidebar-width);
    position: fixed;
    top: 0;
    z-index: 3;
    width: 375px;
    pointer-events: none;
  }

  section {
    width: 100%;
    background-color: var(--color-purple);
    display: inline-block;
  }

  .menu {
    pointer-events: all;
    height: 100vh;
  }

  .button-container {
    display: flex;
    justify-content: center;
  }

  .button-grid {
    margin-top: 33vh;
    margin-bottom: 33vh;
    width: 375px;
    height: 34vh;
    display: flex;
    justify-content: space-around;
    flex-wrap: wrap;
  }

  .button {
    background-color: var(--color-white);
    color: var(--color-purple);
    margin: var(--gap);
    text-align: center;
    white-space: nowrap;
  }

  .cross {
    position: absolute;
    bottom: 0;
    right: 0;
    margin: var(--gap-s);
  }
  .cross-top {
    top: 0;
    right: 0;
    margin: var(--gap-s);
    position: absolute;
  }
</style>
