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
    class:reply-line={!flagging && (replying || comment.replies.length > 0)}
    class:flagging
    transition:scale|local
  >
    <cite>{comment.author.username}</cite>
    {comment.content}
    <div class="link-container">
      <button on:click|preventDefault={() => (replying = true)}>Reply</button>
      <button on:click|preventDefault={() => (flagging = true)}>Flag</button>
    </div>
  </div>

  {#if flagging}
    <ContentTextForm
      focus={true}
      level="warn"
      placeholder="Tell us what's wrong"
      buttonText="Report"
      save={saveFlagComment}
    />
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

  .link-container > * {
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

  .flagging {
    background-color: #f8e5e5;
    border: 2px solid #b60000;
    padding: calc(var(--gap) - 2px);
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
