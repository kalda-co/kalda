<script lang="ts">
  import type { Comment, User } from "../state";
  import {
    createReply,
    reportReply,
    reportComment,
    createReaction,
  } from "../backend";
  import ContentTextForm from "./ContentTextForm.svelte";
  import ContentBubble from "./ContentBubble.svelte";

  export let comment: Comment;
  export let currentUser: User;
  let replying = false;

  function toggleReplying() {
    replying = !replying;
  }

  async function saveReply(content: string) {
    let reply = await createReply(comment.id, content);
    comment.replies = [...comment.replies, reply];
    replying = false;
  }

  let replyLine: boolean;
  $: {
    replyLine = replying || comment.replies.length > 0;
  }
</script>

<article>
  <ContentBubble
    item={comment}
    report={reportComment}
    reply={toggleReplying}
    reaction={createReaction}
    {currentUser}
    {replyLine}
  />

  <div class="replies">
    {#each comment.replies as reply (reply.id)}
      <ContentBubble
        item={reply}
        report={reportReply}
        reply={toggleReplying}
        reaction={createReaction}
        {currentUser}
      />
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
</style>
