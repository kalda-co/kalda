<script lang="ts">
  import type { User } from "./state";
  import type { Post } from "./state";
  export let user: User;
  export let post: Post;
</script>

<article>
  <div class="card-wide">
    <h1>
      Hi,
      <cite>{user.username}</cite> !
    </h1>
    <h2>Today's reflection question.</h2>
    <div class="card">
      <p class="question">{post.content}</p>
      <a href="/app">
        <button>Post a reflection</button>
      </a>
    </div>
  </div>
  <section>
    <h2>Activities</h2>
    <div class="card background-pink">
      <a href="/app">
        <img src="images/calendar-icon-white.svg" alt="calendar icon" />
        <p>Date and Time</p>
      </a>
      <h1>Group therapy</h1>
      <p>Learn more about weekly group therapy</p>
    </div>
  </section>
</article>

<style>
  cite {
    word-break: break-all;
  }

  section {
    padding: var(--gap);
  }

  button {
    border: solid 1px var(--color-purple);
    padding: 16px 24px;
    border-radius: 40px;
    font-weight: 600;
  }
  .card-wide {
    background-color: var(--color-purple);
    color: var(--color-white);
    border-bottom-left-radius: 30px;
    border-bottom-right-radius: 30px;
    padding: var(--gap);
  }

  .question {
    font-size: 24px;
    font-weight: 600;
  }

  .background-pink {
    background-image: url("/images/pink-jellyfish.png");
    background-repeat: no-repeat;
  }

  .card {
    padding: var(--gap);
    background-color: var(--color-white);
    border-radius: 20px;
    color: var(--color-purple);
  }

  .card.background-pink {
    color: var(--color-white);
  }

  .card.background-pink a {
    display: flex;
    padding-top: var(--gap-xl);
    color: var(--color-white);
  }

  .card img {
    padding-right: var(--gap-s);
  }

  .card h1 {
    margin: 0px;
  }
</style>
