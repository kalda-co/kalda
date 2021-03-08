<script lang="ts">
  import type { Page, User, Post, Therapy } from "./state";

  import { formattedDatetime } from "./date";

  export let user: User;
  export let post: Post;
  export let pool: Post;
  export let therapy: Therapy | undefined;
  export let navigateTo: (page: Page) => any;

  function go(page: Page) {
    return () => {
      navigateTo(page);
    };
  }
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
      <button on:click|preventDefault={go("daily-reflection")}
        >Post a reflection</button
      >
    </div>
  </div>

  {#if therapy}
    <section>
      <h2>Activities</h2>
      <div class="card background-pink">
        <button
          class="button-link"
          on:click|preventDefault={go("therapy-sessions")}
        >
          <div class="date-container">
            <img src="images/calendar-icon-white.svg" alt="calendar icon" />
            <p>{formattedDatetime(therapy.startsAt)}</p>
          </div>
          <h1 class="align-left">Group therapy</h1>
        </button>
        <button
          class="button-link"
          on:click|preventDefault={go("group-therapy-info")}
        >
          <p>
            <span class="underline">Learn more</span> about weekly group therapy.
          </p></button
        >
      </div>
    </section>
  {/if}

  {#if pool}
    <section class="pool">
      <div class="card background-purple">
        <button class="button-link" on:click|preventDefault={go("will-pool")}>
          <h1 class="align-left">Will Pool</h1>
          <p class="align-left">
            <span class="underline">Make a commitment</span> to do something that
            you need to get done
          </p>
        </button>
      </div>
    </section>
  {/if}
</article>

<style>
  cite {
    word-break: break-all;
  }

  section {
    padding: var(--gap);
    padding-bottom: 0px;
  }

  button {
    border: solid 1px var(--color-purple);
    padding: 16px 24px;
    border-radius: 40px;
    font-weight: 600;
  }

  .pool {
    padding-top: 0px;
  }
  .align-left {
    text-align: left;
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
    background-image: url("./images/pink-jellyfish.png");
    background-repeat: no-repeat;
  }

  .background-purple {
    background-image: url("./images/purple-jellyfish.png");
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

  .card.background-purple {
    color: var(--color-white);
  }

  .card.background-pink .date-container {
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

  .background-purple h1 {
    padding-top: 80px;
  }

  .button-link {
    border: none;
    color: unset;
    font-weight: unset;
    padding: unset;
  }

  .underline {
    text-decoration: underline;
  }
</style>
