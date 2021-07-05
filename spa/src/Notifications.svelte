<script lang="ts">
  import type { CommentNotification } from "./state";

  export let notifications: CommentNotification[];
</script>

<article class="content">
  {#each notifications as notification}
    <div class="card">
      <div class="card-text">
        <p>
          {notification.replyAuthor.username} replied to your comment: "{notification.commentContent}"
          with: "{notification.replyContent}
          <!-- {notification.commentContent} -->
        </p>
      </div>
    </div>
  {/each}
</article>
