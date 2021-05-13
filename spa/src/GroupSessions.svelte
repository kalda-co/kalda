<script lang="ts">
  import type { Therapy } from "./state";
  import { link } from "svelte-routing";
  import { datetimeToURI, fixDate } from "./date";

  export let therapies: Therapy[];

  function therapyImage(index: number) {
    let images = [
      "/images/therapy_swirls.png",
      "/images/sea-cloud.png",
      "/images/purple-jellyfish2.png",
      "/images/sea.png",
    ];
    return images[index % images.length];
  }
</script>

<article class="content">
  <div class="card-text-only">
    <p>
      All events happen on Zoom. When the event is live you can connect here or
      via a link in your email inbox.
    </p>
  </div>
  <h1>Coming Up</h1>

  {#each therapies as therapy, i (therapy.id)}
    <div class="card">
      <div
        class="card-image"
        style="background-image: url({therapyImage(i)})"
      />
      <div class="card-text">
        <div class="date-container">
          <img src="images/calendar-dark.svg" alt="calendar icon" />
          <p>{fixDate(therapy.startsAt)}</p>

          <a href={datetimeToURI(therapy)} target="_blank" rel="nofollow">
            <p class="link">Add to calendar</p>
          </a>
        </div>
        <h1>{therapy.title}</h1>
        <h2>Led by {therapy.therapist}</h2>
        <h4>{therapy.credentials}</h4>
        <p class="end-line">{therapy.description}</p>
        <a
          class="button zoom-button"
          target="_blank"
          rel="noopener"
          href={therapy.link}><button class="button">Zoom link</button></a
        >
        <a use:link href="/group-info" class="button-link">Learn more.</a>
      </div>
    </div>
  {/each}
</article>

<style>
  .date-container {
    display: flex;
  }

  .date-container img {
    padding-right: var(--gap-s);
  }

  .card {
    margin-bottom: var(--gap);
  }

  .card h1,
  .card h2,
  .card p {
    margin-top: var(--gap-s);
    margin-bottom: var(--gap-s);
    color: var(--font-color-dark);
  }

  .card-text {
    background-color: var(--color-grey);
    padding: var(--gap);
    border-radius: 0 0 20px 20px;
  }

  .card-text-only {
    border-radius: 20px;
    background-color: var(--color-grey);
    padding: var(--gap);
  }

  .card-image {
    height: 250px;
    border-radius: 20px 20px 0 0;
    background-position: center;
    background-size: cover;
  }

  .end-line {
    padding-bottom: 24px;
  }

  .zoom-button {
    border: solid 1px var(--color-purple);
    padding: 16px 24px;
    border-radius: 40px;
    font-weight: 600;
    padding: var(--gap);
    margin-right: var(--gap);
  }

  .link {
    padding-left: var(--gap-s);
    color: var(--color-white);
    text-decoration: underline;
  }
</style>
