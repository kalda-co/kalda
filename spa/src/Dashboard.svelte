<script lang="ts">
  import type { User, Post, Therapy } from "./state";
  import { readableDate, readableTime } from "./date";
  import { link } from "svelte-routing";

  export let user: User;
  export let post: Post | undefined;
  export let pool: Post | undefined;
  export let therapy: Therapy | undefined;
</script>

<article>
  {#if post}
    <div class="todays-reflection">
      <div class="content">
        <h1 class="hi">
          Hi, {user.username}!
        </h1>
        <h2>Today's reflection question.</h2>
        <div class="card">
          <p class="question">{post.content}</p>
          <a use:link href="/daily-reflection">
            <div class="post-button">Post a reflection</div>
          </a>
        </div>
      </div>
    </div>
  {/if}

  {#if therapy}
    <section class="content">
      <h2>Activities</h2>
      <div class="card background-pink">
        <div class="date-container">
          <img class="inline-icon" src="images/cal.svg" alt="calendar icon" />
          <p>
            {readableDate(therapy.startsAt)}, {readableTime(therapy.startsAt)} (British
            Summer Time)
          </p>
          <!-- <a href={datetimeToURI(therapy)} target="_blank" rel="nofollow">
            <p class="link">Add to calendar</p>
          </a> -->
        </div>
        <div class="therapy-session">
          <a use:link href="/therapy-sessions">
            <h1>Group Mindfulness Sessions</h1>
          </a>
          <a use:link href="/group-info">
            <span class="underline">Learn more</span> about weekly group sessions.
          </a>
        </div>
      </div>
    </section>
  {/if}

  {#if pool}
    <section class="content">
      <a use:link href="/will-pool">
        <div class="card background-purple pointer">
          <h1>Will Pool</h1>
          <p>
            <span class="underline">Make a commitment</span> to do something that
            you need to get done
          </p>
        </div>
      </a>
    </section>
  {/if}
</article>

<style>
  .hi {
    word-break: break-all;
  }

  .post-button {
    border: solid 1px var(--color-purple);
    padding: 16px 24px;
    border-radius: 40px;
    font-weight: 600;
    display: inline-block;
  }

  .todays-reflection {
    background-color: var(--color-purple);
    color: var(--color-white);
  }

  .todays-reflection .content {
    background-color: var(--color-purple);
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
  .card.background-pink a,
  .card.background-pink {
    color: var(--color-white);
  }

  .card.background-pink {
    height: 220px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
  }

  .card.background-pink .date-container {
    display: flex;
  }

  .card h1 {
    margin: 0px;
  }

  .background-purple h1 {
    padding-top: 80px;
  }

  .underline {
    text-decoration: underline;
  }

  section {
    padding-bottom: var(--gap);
  }

  .inline-icon {
    margin-right: var(--gap-s);
    width: 34px;
  }
</style>
