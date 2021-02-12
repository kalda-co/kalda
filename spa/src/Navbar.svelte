<nav class="navbar">
  <img
    src="/images/kalda-rainbow-purple-logo.svg"
    alt="Kalda's Rainbow Logo"
    class="logo"
  />
  <h1>Daily reflection</h1>
  <img src="/images/burger-menu.svg" alt="hamburger-menu" class="hamburger" />
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
</style>
