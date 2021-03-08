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

<article>
  <div class="card">
    <p>
      All events happen on Zoom. When the event is live you can connect here or
      via a link in your email inbox.
    </p>
  </div>
  <h1>This Week</h1>

  {#if therapy}
    <div class="guideline-card">
      <div class="card-image">
        <img
          src="/images/therapy_swirls.png"
          alt="Photograph of water, oil and paint swirls, blue and pink"
        />
      </div>
      <div class="card-text">
        <div class="date-container">
          <img src="images/calendar-dark.svg" alt="calendar icon" />
          <p>{formattedDatetime(therapy.startsAt)}</p>
        </div>
        <h1>{therapy.title}</h1>
        <h2>Led by {therapy.therapist}, {therapy.credentials}</h2>
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
  article {
    padding: var(--gap);
  }

  .date-container {
    display: flex;
  }

  .date-container img {
    padding-right: var(--gap-s);
  }
  .card {
    padding: var(--gap);
    background-color: var(--color-grey);
    border-radius: 20px;
    color: var(--font-color-dark);
  }

  .guideline-card h1,
  .guideline-card h2,
  .guideline-card p {
    margin-top: var(--gap-s);
    margin-bottom: var(--gap-s);
    color: var(--font-color-dark);
  }

  .card-text {
    --border: 2px solid var(--color-grey);
    background-color: var(--color-grey);
    padding: var(--gap);
    margin-top: calc(0px - var(--gap));
    border-left: var(--border);
    border-bottom: var(--border);
    border-bottom-left-radius: 20px;
    border-bottom-right-radius: 20px;
    margin-bottom: var(--gap-s);
  }

  .card-image img {
    border-top-left-radius: 20px;
    border-top-right-radius: 20px;
  }

  .button-link {
    border: none;
    color: unset;
    font-weight: unset;
    padding: unset;
    padding-left: 16px;
    color: var(--color-purple);
    text-decoration: underline;
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
