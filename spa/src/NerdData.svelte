<script>
  import { messages } from "./log";
</script>

<article class="nerd-wrapper">
  <h1>Data for nerds</h1>

  <ol>
    {#if $messages.length === 0}
      There are no logged messages
    {/if}
    {#each $messages as { level, time, text }}
      <li>{time.toLocaleTimeString()} {level}: {text}</li>
    {/each}
  </ol>
</article>

<style>
  .nerd-wrapper {
    margin: var(--gap);
  }
</style>
