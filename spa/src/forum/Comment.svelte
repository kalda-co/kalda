<script lang="ts">
  import type { Comment, User } from "../state";
  import type { ApiClient } from "../backend";
  import ContentTextForm from "./ContentTextForm.svelte";
  import ContentBubble from "./ContentBubble.svelte";

  export let api: ApiClient;
  export let comment: Comment;
  export let currentUser: User;
  let replying = false;

  function toggleReplying() {
    replying = !replying;
  }

  async function saveReply(content: string) {
    let reply = await api.createReply(comment.id, content);
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
    report={(id, reason) => api.reportComment(id, reason)}
    reply={toggleReplying}
    reaction={(id, relate, sendLove) =>
      api.createCommentReaction(id, relate, sendLove)}
    {currentUser}
    {replyLine}
  />

  <div class="replies">
    {#each comment.replies as reply (reply.id)}
      <ContentBubble
        item={reply}
        report={(id, reason) => api.reportReply(id, reason)}
        reply={toggleReplying}
        reaction={(id, relate, sendLove) =>
          api.createReplyReaction(id, relate, sendLove)}
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
