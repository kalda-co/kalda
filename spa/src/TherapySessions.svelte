<script lang="ts">
  import type { Therapy, Page } from "./state";
  import { formattedDatetime } from "./date";

  export let therapy: Therapy | undefined;

  export let navigateTo: (page: Page) => any;
  function go(page: Page) {
    return () => {
      navigateTo(page);
    };
  }
</script>

<article class="content">
  <div class="card-text-only">
    <p>
      All events happen on Zoom. When the event is live you can connect here or
      via a link in your email inbox.
    </p>
  </div>
  <h1>This Week</h1>

  {#if therapy}
    <div class="card">
      <div class="card-image swirls" />
      <!-- <img
          src="/images/therapy_swirls.png"
          alt="Photograph of water, oil and paint swirls, blue and pink"
        /> -->
      <div class="card-text">
        <div class="date-container">
          <img src="images/calendar-dark.svg" alt="calendar icon" />
          <p>{formattedDatetime(therapy.startsAt)}</p>
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
        <button
          on:click|preventDefault={go("group-therapy-info")}
          class="button-link"
        >
          Learn more.
        </button>
      </div>
    </div>
  {/if}
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

  .card-image {
    height: 250px;
    border-radius: 20px 20px 0 0;
    background-position: center;
    background-size: cover;
  }

  .card-text-only {
    border-radius: 20px;
    background-color: var(--color-grey);
    padding: var(--gap);
  }

  .swirls {
    background-image: url("/images/therapy_swirls.png");
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
  }
</style>
