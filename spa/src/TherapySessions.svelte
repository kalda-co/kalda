<script lang="ts">
  import type { Therapy } from "./state";
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
  <div class="card-wide">
    <p>
      All events happen on Zoom. When the event is live you can connect here or
      via a link in your email inbox.
    </p>
  </div>
  <h1>This Week</h1>
  <div class="guideline-card">
    <div class="card-image">
      <div class="card-image">
        <img
          src="/images/therapy_swirls.png"
          alt="Photograph of water, oil and paint swirls, blue and pink"
        />
      </div>
    </div>
    <div class="card-text">
      <div class="date-container">
        <img src="images/calendar-icon-white.svg" alt="calendar icon" />
        <p>{formattedDatetime(therapy.event_datetime)}</p>
      </div>
      <h1>{therapy.title}</h1>
      <h2>Led by{therapy.therapist}, {therapy.credentials}.</h2>
      <p>{therapy.description}</p>

      <a class="button" target="_blank" rel="noopener" href={therapy.link}
        >Zoom link</a
      >
      <button
        on:click|preventDefault={go("group-therapy-info")}
        class="button-link"
      >
        Learn more.
      </button>
    </div>
  </div>
</article>

<style>
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

  .button-link {
    border: none;
    color: unset;
    font-weight: unset;
    padding: unset;
  }
</style>
