<script lang="ts">
  import type { Page, User, Post, Therapy } from "./state";

  export let user: User;
  export let post: Post;
  export let therapy: Therapy;
  export let navigateTo: (page: Page) => any;

  function go(page: Page) {
    return () => {
      navigateTo(page);
    };
  }

  function formatted_datetime(datetime: Date) {
    const dd = datetime.getDate();
    const mm = datetime.getMonth();
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    const mon = months[mm];
    const day = ["Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun"][
      datetime.getDay()
    ];
    const year = datetime.getFullYear();
    const tz = datetime.getTimezoneOffset();
    const hh = datetime.getHours();
    const mi = datetime.getMinutes();
    return `${day} ${mon} ${dd}, ${year} at ${hh}:${mi} GMT+${tz}`;
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
  <section>
    <h2>Activities</h2>
    <div class="card background-pink">
      <a target="_blank" href={therapy.link}>
        <img src="images/calendar-icon-white.svg" alt="calendar icon" />
        <p>{formatted_datetime(therapy.event_datetime)}</p>
      </a>
      <h1>Group therapy</h1>
      <button
        class="button-link"
        on:click|preventDefault={go("group-therapy-info")}
      >
        <p>Learn more about weekly group therapy</p>
      </button>
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
    background-image: url("./images/pink-jellyfish.png");
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

  .button-link {
    border: none;
    color: unset;
    font-weight: unset;
    padding: unset;
  }
</style>
