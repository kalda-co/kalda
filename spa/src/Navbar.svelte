<script>
  let menu = false;

  function toggleMenu() {
    menu = !menu;
  }
  import { fly } from "svelte/transition";
</script>

<div transition:fly|local class:menu>
  {#if menu}
    <section transition:fly={{ y: 200, duration: 1000 }}>stuff</section>
  {/if}

  <nav class="navbar">
    <img
      src="/images/kalda-rainbow-purple-logo.svg"
      alt="Kalda's Rainbow Logo"
      class="logo"
    />
</div>
    <h1>Daily reflection</h1>
    <button on:click|preventDefault={toggleMenu}>
      <img
        src="/images/burger-menu.svg"
        alt="hamburger-menu"
        class="hamburger"
      />
    </button>
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

  section {
    height: 90px;
    width: 100%;
    background-color: var(--color-purple);
  }
</style>
