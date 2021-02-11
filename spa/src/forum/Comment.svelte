<script lang="ts">
  import type { Comment } from "../state";
  import { scale } from "svelte/transition";

  export let comment: Comment;
</script>

<article>
  <div class="comment" transition:scale|local>
    <cite>{comment.author.username}</cite>
    {comment.content}
  </div>

  {#each comment.replies as reply}
    <div class="reply">
      <cite>{reply.author.username}</cite>
      {reply.content}
    </div>
  {/each}
</article>

<style>
  .reply,
  .comment {
    background-color: var(--color-grey);
    border-radius: 20px;
    padding: var(--gap);
    margin-bottom: var(--gap-s);
  }

  .reply {
    margin-left: var(--gap-l);
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
