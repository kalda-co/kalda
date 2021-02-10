<script lang="ts">
  export let author: string;
  export let text: string;

  import { scale } from "svelte/transition";
</script>

<div class="comment" transition:scale|local>
  <cite>{author}</cite>
  {text}
</div>

<style>
  .comment {
    background-color: var(--color-grey);
    border-radius: 20px;
    padding: var(--gap);
    margin-bottom: var(--gap);
  }

  cite {
    display: block;
    color: var(--color-purple);
    margin-bottom: var(--gap-s);
    font-style: normal;
    font-size: var(--font-size-s);
    font-weight: 500;
  }
</style>
