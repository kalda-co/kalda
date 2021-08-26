<script lang="ts">
  import CommentComponent from "./Comment.svelte";
  import ContentTextForm from "./ContentTextForm.svelte";
  import { link } from "svelte-routing";
  import type { Post, Comment } from "../state";
  import type { ApiClient, Response } from "../backend";
  import type { AppState } from "../state";

  export let api: ApiClient;
  export let post: Post;
  export let placeholder: string;
  export let commentName: string;
  export let state: AppState;

  let currentUser = state.currentUser;

  async function saveComment(content: string): Promise<Response<Comment>> {
    let response = await api.createComment(post.id, content);
    if (response.type === "Success") {
      post.comments = [response.resource, ...post.comments];
    }
    return response;
  }

  function countReplies(postComments: Array<Comment>) {
    let replyNum = postComments.reduce(
      (count, comment) => count + comment.replies.length,
      0
    );
    return replyNum;
  }

  function makeCommentsCountText() {
    if (currentUser.hasSubscription) {
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
    } else {
      return "responses hidden";
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
    {#if state.currentUser.hasSubscription}
      <ContentTextForm {placeholder} save={saveComment} buttonText="Send" />
      {#each post.comments as comment (comment.id)}
        <CommentComponent {comment} {currentUser} {api} />
      {/each}
    {:else}
      <div class="form-dupe-container">
        <div class="form-dupe">
          <p>Subscribe to save & share</p>
        </div>
        <a use:link href="/subscription">
          <button class="button subscribe-button">Subscribe</button>
        </a>
      </div>
    {/if}
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
    font-size: var(--font-size-l);
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

  .form-dupe-container {
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: space-between;
    border-radius: 30px;
    border: 2px solid var(--color-purple);
    padding-left: var(--gap);
    margin-bottom: var(--gap);
    position: relative;
    background-color: var(--color-white);
  }

  .subscribe-button {
    background-color: #8bffde;
    color: #404040;
    margin-right: var(--gap-s);
  }
</style>
