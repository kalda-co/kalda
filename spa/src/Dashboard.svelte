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
  <div class="todays-reflection">
    <div class="content">
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
  </div>

  {#if therapy}
    <section class="content">
      <h2>Activities</h2>
      <div class="card background-pink">
        <div class="date-container">
          <img src="images/calendar-icon-white.svg" alt="calendar icon" />
          <p>{formattedDatetime(therapy.startsAt)}</p>
        </div>
        <button
          class="button-link"
          on:click|preventDefault={go("therapy-sessions")}
        >
          <h1 class="align-left">Group therapy</h1>
        </button>
        <button
          class="button-link"
          on:click|preventDefault={go("group-therapy-info")}
        >
          <span class="underline">Learn more</span> about weekly group therapy.
        </button>
      </div>
    </section>
  {/if}

  {#if pool}
    <section class="content">
      <div
        class="card background-purple pointer"
        on:click|preventDefault={go("will-pool")}
      >
        <h1>Will Pool</h1>
        <p>
          <span class="underline">Make a commitment</span> to do something that you
          need to get done
        </p>
      </div>
    </section>
  {/if}
</article>

<style>
  cite {
    word-break: break-all;
  }

  button {
    border: solid 1px var(--color-purple);
    padding: 16px 24px;
    border-radius: 40px;
    font-weight: 600;
  }

  .todays-reflection {
    background-color: var(--color-purple);
    color: var(--color-white);
  }

  .todays-reflection .content {
    padding: var(--gap);
  }

  @media (max-width: 630px) {
    .todays-reflection {
      border-bottom-left-radius: 30px;
      border-bottom-right-radius: 30px;
    }
  }

  .question {
    font-size: 24px;
    font-weight: 600;
  }

  .background-pink {
    background-image: url("./images/pink-jellyfish.png");
  }

  .background-purple {
    background-image: url("./images/purple-jellyfish.png");
  }

  .card {
    padding: var(--gap);
    background-color: var(--color-white);
    background-position: center;
    background-size: cover;
    border-radius: 20px;
    color: var(--color-purple);
  }

  .card.background-purple,
  .card.background-pink {
    color: var(--color-white);
  }

  .card.background-pink .date-container {
    display: flex;
    padding-top: var(--gap-xl);
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

  section {
    margin-bottom: var(--gap);
  }
</style>
