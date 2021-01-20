<script lang="ts">
  import Navbar from "./Navbar.svelte";
  import DailyReflection from "./forum/DailyReflection.svelte";
  import type { Comment } from "./forum/data";

  export let author: string;
  export let question: string;
  export let comments: Array<Comment>;
</script>

<main>
  <Navbar />
  <DailyReflection {author} {question} {comments} />
</main>

<style>
  main {
    width: 375px;
    max-width: 100%;
    margin: 0 auto;
    background-color: var(--color-white);
  }
</style>
