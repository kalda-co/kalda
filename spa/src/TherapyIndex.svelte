<script lang="ts">
  import type { Therapy } from "./state";
  import { formattedDatetime } from "./date";

  export let therapy: Therapy | undefined;
  // export let navigateTo: (page: Page) => any;

  // function go(page: Page) {
  //   return () => {
  //     navigateTo(page);
  //   };
  // }
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
        <!-- </div>
      <h1>{therapy.title}</h1>
      <h2>Led by{therapy.therapist}, {therapy.credentials}.</h2>
      <p>{therapy.description}</p> -->
        <a target="_blank" rel="noopener" href={therapy.link}>Zoom link</a>
        <button class="button-link"> Learn more</button>
      </div>
    </div>
  </div>
</article>
