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
          <img src="images/cal-dark.svg" alt="calendar icon" />
          <p>{fixDate(therapy.startsAt)}</p>
        </div>
        <h1>{therapy.title}</h1>
        <h2>Led by {therapy.therapist}</h2>
        <h4>{therapy.credentials}</h4>
        <p>{therapy.description}</p>
        <a use:link href="/group-info" id="learn-more">Learn more.</a>
        <div class="button-container">
          <a
            class="zoom-button"
            target="_blank"
            rel="noopener"
            href={therapy.link}><button>Zoom link</button></a
          >
          <a
            class="light-button"
            target="_blank"
            rel="nofollow"
            href={datetimeToURI(therapy)}
            ><button>Add to calendar</button>
          </a>
        </div>
      </div>
    </div>
  {/each}
</article>

<style>
  .date-container {
    display: flex;
  }

  .date-container p {
    font-size: 16px;
  }
  .date-container img {
    padding-right: var(--gap-s);
    width: 38px;
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

  .button-container {
    margin-top: 34px;
    padding-bottom: 24px;
  }

  .zoom-button {
    border: solid 2px var(--color-purple);
    padding: 16px 24px;
    border-radius: 40px;
    font-weight: 600;
    padding-top: var(--gap);
    padding-bottom: var(--gap);
    padding-right: var(--gap);
    margin-right: var(--gap);
    background-color: #4a00b0;
    color: #ededed;
  }
  a.zoom-button button {
    color: #ededed;
  }

  .light-button {
    border: solid 2px var(--color-purple);
    padding: 16px 24px;
    border-radius: 40px;
    font-weight: 600;
    padding: var(--gap);
    margin-right: var(--gap);
    background-color: #eeeeee;
  }

  #learn-more {
    margin-top: 16px;
    margin-bottom: 8px;
    padding-bottom: 24px !important;
    padding-top: 24px !important;
    text-decoration: underline;
  }
</style>
