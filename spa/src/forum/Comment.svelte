<script lang="ts">
  import type { Comment } from "../state";
  import { createReply, reportReply, reportComment } from "../backend";
  import ContentTextForm from "./ContentTextForm.svelte";
  import ContentBubble from "./ContentBubble.svelte";

  export let comment: Comment;
  let replying = false;

  function toggleReplying() {
    replying = !replying;
  }

  async function saveReply(content: string) {
    let reply = await createReply(comment.id, content);
    comment.replies = [...comment.replies, reply];
    replying = false;
  }
</script>

<article>
  <!-- TODO: reply line -->

  <!-- <div
    class="comment"
    class:reply-line={!reporting && (replying || comment.replies.length > 0)}
    class:reporting
    transition:scale|local
  >
    <cite>{comment.author.username}</cite>
    {comment.content}
    <div class="link-container">
      <button on:click|preventDefault={() => (replying = !replying)}
        >Reply</button
      >
      <button on:click|preventDefault={() => (reporting = !reporting)}
        >Report</button
      >
    </div>
  </div> -->

  <ContentBubble item={comment} report={reportComment} reply={toggleReplying} />

  <div class="replies">
    {#each comment.replies as reply (reply.id)}
      <ContentBubble item={reply} report={reportReply} reply={toggleReplying} />
    {/each}

    {#if replying}
      <div class="form">
        <ContentTextForm
          focus={true}
          placeholder="Post a reply"
          buttonText="Reply"
          save={saveReply}
        />
      </div>
    {/if}
  </div>
</article>

<style>
  .replies {
    margin-left: var(--gap-l);
    z-index: 1; /* Bring above curvy line from comment */
  }

  .reply-line::after {
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
</style>
