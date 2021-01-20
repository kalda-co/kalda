<script lang="ts">
</script>

<nav class="navbar">
  <img src="logo" alt="Kalda's Logo" class="logo" />
  <h1>Daily reflection</h1>
  <span class="hamburger">HAM</span>
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

    /* TODO: icons */
    background-color: var(--color-purple-mid);
  }
</style>
