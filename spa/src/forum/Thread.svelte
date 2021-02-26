<script lang="ts">
  import Comment from "./Comment.svelte";
  import ContentTextForm from "./ContentTextForm.svelte";
  import type { Post } from "../state";
  import { createComment } from "../backend";

  export let post: Post;
  export let placeholder: string;
  export let commentName: string;

  async function saveComment(content: string) {
    let comment = await createComment(post.id, content);
    post.comments = [comment, ...post.comments];
  }

  function makeCommentsCountText() {
    switch (post.comments.length) {
      case 0:
        return `No ${commentName}s yet`;
      case 1:
        return `1 ${commentName}`;
      default:
        return `${post.comments.length} ${commentName}s`;
    }
  }
  let commentsCountText: string;
  $: {
    commentsCountText = makeCommentsCountText();
  }
</script>

<article>
  <section class="post">
    <cite>{post.author.username}</cite>
    <p class="question">{post.content}</p>
    <aside class="trivia">
      <span>
        <img src="/images/speech-icon.svg" alt="A speech bubble icon" />
        {commentsCountText}
      </span>
    </aside>
  </section>

  <section class="comments">
    <ContentTextForm {placeholder} save={saveComment} buttonText="Send" />
    {#each post.comments as comment (comment.id)}
      <Comment {comment} />
    {/each}
  </section>
</article>

<style>
  .post {
    margin-top: var(--gap);
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
