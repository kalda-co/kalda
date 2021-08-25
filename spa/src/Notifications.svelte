<script lang="ts">
  import type { CommentNotification } from "./state";
  import { link } from "svelte-routing";

  export let notifications: CommentNotification[];
</script>

{#each notifications as notification}
  <article class="content">
    <div class="card">
      <div class="card-text">
        <p>
          <span class="author">{notification.replyAuthor.username}</span>
          <span class="italic"> replied to your comment: </span>
          "{notification.commentContent}"
          <span class="italic">with: </span>
          "{notification.replyContent}."
          <span class="underline">
            <a use:link href="/posts/{notification.parentPostId}">
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
