<script lang="ts">
  import Comment from "./Comment.svelte";
  import NewCommentForm from "./NewCommentForm.svelte";
  import type { Comment as CommentType } from "./data";

  export let author: string;
  export let question: string;
  export let comments: Array<CommentType>;

  let currentUser = "You";

  async function saveComment(content: string) {
    console.log("todo: save data", content);
    comments = [{ author: currentUser, text: content }, ...comments];
    return true;
  }

  function commentsCountText() {
    switch (comments.length) {
      case 0:
        return "No comments";
      case 1:
        return "1 comment";
      default:
        return `${comments.length} comments`;
    }
  }
</script>

<article>
  <section class="post">
    <cite>{author}</cite>
    <p class="question">{question}</p>
    <aside class="trivia">
      <span>
        <img src="speech-icon.svg" alt="A speech bubble icon" />
        {commentsCountText()}
      </span>
      <span>
        <img src="clock-icon.svg" alt="A clock icon" />
        Expires tomorrow 9.00am
      </span>
    </aside>
  </section>

  <section class="comments">
    <NewCommentForm {saveComment} />

    {#each comments as comment (comment.text)}
      <Comment author={comment.author} text={comment.text} />
    {/each}
  </section>
</article>

<style>
  .post {
    padding: var(--gap);
    background-color: var(--color-purple-light);
    color: var(--color-purple);
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
