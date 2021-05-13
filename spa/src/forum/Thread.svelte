<script lang="ts">
  import CommentComponent from "./CommentComponent.svelte";
  import ContentTextForm from "./ContentTextForm.svelte";
  import type { Post, User, Comment } from "../state";
  // import type { Comment as Alias } from "../state";
  import { createComment } from "../backend";

  export let post: Post;
  export let placeholder: string;
  export let commentName: string;
  export let currentUser: User;
  // export let comments: Array<Comment>;

  // let comment: Comment;

  async function saveComment(content: string) {
    let comment = await createComment(post.id, content);
    post.comments = [comment, ...post.comments];
  }

  function countReplies(postComments: Array<Comment>) {
    // let replies = post.comments[0].replies;
    // let replyAcc = 0;
    let replyNum = postComments.reduce(
      (count, comment) => count + comment.replies.length,
      0
    );
    // replies.forEach(reply);
    console.log("repliesCount", replyNum);
    return replyNum;
  }

  function makeCommentsCountText() {
    switch (post.comments.length) {
      case 0:
        return `No ${commentName}s yet`;
      case 1:
        let replyCount = post.comments[0].replies.length;
        let replyCommentCount = replyCount + 1;
        return `${replyCommentCount} ${commentName}(s)`;
      default:
        let rcc2 = post.comments.length + countReplies(post.comments);
        return `${rcc2} ${commentName}s`;
    }
  }
  let commentsCountText: string;
  $: {
    commentsCountText = makeCommentsCountText();
  }
</script>

<article>
  <section class="post">
    <div class="content">
      <cite>{post.author.username}</cite>
      <p class="question">{post.content}</p>
      <aside class="trivia">
        <span>
          <img src="/images/speech-icon.svg" alt="A speech bubble icon" />
          {commentsCountText}
        </span>
      </aside>
    </div>
  </section>

  <section class="comments content">
    <ContentTextForm {placeholder} save={saveComment} buttonText="Send" />
    {#each post.comments as comment (comment.id)}
      <CommentComponent {comment} {currentUser} />
    {/each}
  </section>
</article>

<style>
  .post {
    padding: var(--gap) 0;
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
