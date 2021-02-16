<script lang="ts">
  import type { User } from "../state";
  import { scale } from "svelte/transition";

  interface Item {
    author: User;
    content: string;
  }

  export let item: Item;
</script>

<div transition:scale|local class="bubble">
  <cite>{item.author.username}</cite>
  {item.content}
</div>

<style>
  .bubble {
    background-color: var(--color-grey);
    border-radius: 20px;
    padding: var(--gap);
    margin-bottom: var(--gap-s);
    position: relative;
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
