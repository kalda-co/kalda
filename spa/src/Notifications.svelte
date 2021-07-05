<script lang="ts">
  import type { CommentNotification } from "./state";

  export let notifications: CommentNotification[];
</script>

<article class="content">
  {#each notifications as notification}
    <div class="card">
      <div class="card-text">
        <p>
          <!-- {notification.reply_author.username} replied to your comment: "{notification.comment_content}" -->
          <!-- with: "{notification.reply_content} -->
          {notification.comment_content}
        </p>
      </div>
    </div>
  {/each}
</article>
