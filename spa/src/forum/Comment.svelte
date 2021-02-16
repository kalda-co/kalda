<script lang="ts">
  import type { Comment } from "../state";
  import { scale } from "svelte/transition";
  import { createReply } from "../backend";
  import { createFlagComment } from "../backend";
  import ContentTextForm from "./ContentTextForm.svelte";

  export let comment: Comment;
  let replying = false;
  let flagging = false;

  async function saveReply(content: string) {
    let reply = await createReply(comment.id, content);
    comment.replies = [...comment.replies, reply];
    replying = false;
  }

  async function saveFlagComment(reporter_reason: string) {
    await createFlagComment(comment.id, reporter_reason);
    flagging = false;
  }
</script>

<article>
  <div
    class="comment"
    class:with-replies={replying || comment.replies.length > 0}
    class:with-flagging={flagging}
    transition:scale|local
  >
    <cite>{comment.author.username}</cite>
    {comment.content}
    <div class="link-container">
      <div class="reply-link">
        <button on:click|preventDefault={() => (replying = true)}>Reply</button>
      </div>
      <div class="flag-link">
        <button on:click|preventDefault={() => (flagging = true)}>Flag</button>
      </div>
    </div>
  </div>

  {#if flagging}
    <div class="flagging">
      <ContentTextForm
        focus={true}
        placeholder="Tell us what's wrong"
        buttonText="Report"
        save={saveFlagComment}
      />
    </div>
  {/if}

  {#each comment.replies as reply (reply.id)}
    <div transition:scale|local class="reply">
      <cite>{reply.author.username}</cite>
      {reply.content}
    </div>
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
</article>

<style>
  .link-container {
    display: flex;
    justify-content: space-between;
  }

  .reply-link {
    text-decoration: underline;
    font-size: var(--font-size-s);
    margin-top: var(--gap-s);
    cursor: pointer;
  }

  .flag-link {
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

  .form,
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
  .with-flagging.with-replies::after {
    --border: 2px solid #f8e5e5;
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

  .with-flagging {
    background-color: #f8e5e5;
    border: 2px solid #b60000;
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
