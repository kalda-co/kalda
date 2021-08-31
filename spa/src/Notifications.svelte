<script lang="ts">
  import type { AppState, CommentNotification } from "./state";
  import { link } from "svelte-routing";

  export let state: AppState;
  let notifications: Array<CommentNotification> = state.commentNotifications;

  function truncate(content: string): string {
    if (content.length > 30) {
      return content.substring(0, 30) + "...";
    } else {
      return content;
    }
  }
</script>

{#each notifications as notification}
  <article class="content">
    <div class="card">
      <div class="card-text">
        <p>
          <span class="author">{notification.replyAuthor.username}</span>
          <span class="italic"> replied to your comment: </span>
          "{truncate(notification.commentContent)}"
        </p>
        <p>
          <span class="italic">with: </span>
          "{truncate(notification.replyContent)}."
          <span class="underline">
            <a
              use:link
              href="/posts/{notification.parentPostId}/comments/{notification.commentId}/n/{notification.id}"
            >
              See the whole thread
            </a>
          </span>
        </p>
      </div>
    </div>
  </article>
  <hr class="hr-light" />
{/each}

<style>
  .author {
    font-weight: 700;
    padding-right: var(--gap-xs);
  }
  .underline {
    text-decoration: underline;
    padding-right: var(--gap-xs);
  }
  .italic {
    font-style: italic;
    padding-right: var(--gap-xs);
  }
  .hr-light {
    color: lightgray;
    background-color: #eeeeee;
    height: 1px;
    border: none;
  }
</style>
