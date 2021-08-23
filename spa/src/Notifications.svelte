<script lang="ts">
  import type { CommentNotification } from "./state";
  import { link } from "svelte-routing";

  export let notifications: CommentNotification[];
</script>

<article class="content">
  {#each notifications as notification}
    <div class="card">
      <div class="card-text">
        <p>
          {notification.replyAuthor.username} replied to your comment: "{notification.commentContent}"
          with: "{notification.replyContent}.
          <!-- {notification.commentContent} -->

          <a use:link href="/posts/{notification.parentPostId}">
            See the whole thread <span class="underline">here.</span>
          </a>
        </p>
      </div>
    </div>
  {/each}
</article>
