<script lang="ts">
  import type { Comment } from "../state";
  import { scale } from "svelte/transition";

  export let comment: Comment;
</script>

<article>
  <div
    class="comment"
    class:with-replies={comment.replies.length > 0}
    transition:scale|local
  >
    <cite>{comment.author.username}</cite>
    {comment.content}
    <div class="reply-link">
      <a class="reply-link" href="#reply">Reply</a>
    </div>
  </div>

  {#each comment.replies as reply}
    <div class="reply">
      <cite>{reply.author.username}</cite>
      {reply.content}
    </div>
  {/each}
</article>

<style>
  .reply-link {
    text-decoration: underline;
    font-size: var(--font-size-s);
    margin-top: var(--gap-s);
    cursor: pointer;
  }

  .reply,
  .comment {
    background-color: var(--color-grey);
    border-radius: 20px;
    padding: var(--gap);
    margin-bottom: var(--gap-s);
    position: relative;
  }

  .reply {
    margin-left: var(--gap-l);
    z-index: 1; /* Bring above curvy line from comment */
  }

  .with-replies::after {
    --border: 2px solid var(--color-grey);
    content: "";
    position: absolute;
    border-left: var(--border);
    border-bottom: var(--border);
    border-radius: 20px;
    bottom: calc(-1 * var(--gap-l) - var(--gap-s));
    left: 0;
    top: 0;
    right: 0;
    pointer-events: none;
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
