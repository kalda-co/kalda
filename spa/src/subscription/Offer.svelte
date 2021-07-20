<script>
  export let buttonClicked: () => void;
</script>

<div class="offer">
  <div class="content">
    <div class="squids">
      <img
        src="/images/speech-icon.svg"
        alt="A trio of peaceful cartoon squids"
      />
    </div>

    <div class="offer-bubble">
      <h2>Upgrade to Premium</h2>
      <ul>
        <li>Weekly group mental health sessions</li>
        <li>Daily reflection questions in a peer support community</li>
        <li>Mindfulness recordings</li>
        <li>First access to Kalda events</li>
      </ul>
    </div>

    <button class="offer-button" on:click={buttonClicked}>£2.99 / month</button>
  </div>
</div>

<style>
  .offer {
    min-height: 100vh;
    background-color: var(--color-purple);
    padding: var(--gap) 0 var(--gap-xxxl) 0;
    display: flex;
    align-items: center;
  }
  .offer-bubble {
    color: var(--color-purple);
    background-color: var(--color-white);
    padding: var(--gap-l);
    border-radius: var(--gap-l);
    margin: 0 0 var(--gap) 0;
  }
  .offer-bubble h2 {
    font-weight: var(--font-weight-large);
    font-size: var(--font-size-xl);
    line-height: 1;
    margin: 0;
  }
  .offer-bubble ul {
    margin: 0;
  }
  .offer-bubble li {
    margin: var(--gap) 0;
  }
  .offer-bubble li:last-child {
    margin-bottom: 0;
  }
  .offer-button {
    display: block;
    width: 100%;
    background-color: var(--color-white);
    padding: var(--gap);
    border-radius: 100px;
    font-weight: var(--font-weight-large);
  }
  .squids {
    margin-bottom: var(--gap-l);
    text-align: center;
  }
  .squids img {
    height: 150px;
  }
</style>
