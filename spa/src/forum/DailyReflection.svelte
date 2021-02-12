<script lang="ts">
  import Comment from "./Comment.svelte";
  import NewCommentForm from "./NewCommentForm.svelte";
  import type { Post } from "../state";
  import { createComment } from "../backend";

  export let post: Post;

  async function saveComment(post_id: number, content: string) {
    let comment = await createComment(post_id, content);
    const comments = [comment, ...post.comments];
    post = { ...post, comments };
    return true;
  }

  function commentsCountText() {
    switch (post.comments.length) {
      case 0:
        return "No comments";
      case 1:
        return "1 comment";
      default:
        return `${post.comments.length} comments`;
    }
  }
</script>

<article>
  <section class="post">
    <cite>{post.author.username}</cite>
    <p class="question">{post.content}</p>
    <aside class="trivia">
      <span>
        <img src="/images/speech-icon.svg" alt="A speech bubble icon" />
        {commentsCountText()}
      </span>
    </aside>
  </section>

  <section class="comments">
    <NewCommentForm saveComment={(content) => saveComment(post.id, content)} />

    {#each post.comments.reverse() as comment (comment.id)}
      <Comment {comment} />
    {/each}
  </section>
</article>

<style>
  .post {
    padding: var(--gap);
    background-color: var(--color-purple);
    color: var(--color-white);
  }

  cite {
    font-size: var(--font-size-s);
    font-style: normal;
    font-weight: 500;
    margin-bottom: var(--gap-s);
  }

  .question {
    font-weight: 500;
    margin: var(--gap-s) 0;
  }

  .comments {
    padding: var(--gap);
  }

  .trivia > * {
    font-size: var(--font-size-s);
    margin-right: var(--gap);
  }

  .trivia img {
    --size: var(--font-size-s);
    height: var(--size);
    width: var(--size);
    margin-right: var(--gap-xs);
    position: relative;
    top: 1px;
    display: inline-block;
    overflow: hidden;
    /* TODO: icons */
    background-color: var(--color-purple);
  }
</style>
