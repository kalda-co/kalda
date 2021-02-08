<script lang="ts">
  import Navbar from "./Navbar.svelte";
  import DailyReflection from "./forum/DailyReflection.svelte";
  import type { User, Post } from "./state";

  export let post: Post;
  export let currentUser: User;
</script>

<main>
  <Navbar />
  <DailyReflection {post} {currentUser} />
</main>

<style>
  main {
    width: 375px;
    max-width: 100%;
    margin: 0 auto;
    background-color: var(--color-white);
  }
</style>
