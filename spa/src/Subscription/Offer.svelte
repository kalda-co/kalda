<script>
  import { link } from "svelte-routing";
  export let buttonClicked: () => void;
</script>

<div class="offer">
  <a use:link href="/dashboard">
    <button class="close">
      <img src="/images/cross.svg" alt="close menu cross" />
    </button>
  </a>
  <div class="content">
    <div>
      <div class="squids">
        <img
          src="/images/three-jellyfish.svg"
          alt="A trio of peaceful cartoon squids"
        />
      </div>

      <div class="offer-bubble">
        <h2>Upgrade to Premium</h2>
        <ul>
          <li>Weekly group mental health sessions on Zoom</li>
          <li>
            Daily reflection questions in a peer support community, here and in
            your browser
          </li>
          <li>Mindfulness recordings</li>
          <li>First access to Kalda Zoom courses and events</li>
        </ul>
      </div>

      <button class="offer-button" on:click={buttonClicked}
        >£2.99 / month</button
      >
    </div>
  </div>
</div>

<style>
  .offer {
    min-height: 100vh;
    background-color: var(--color-purple);
    padding: 0 0 var(--gap-xxxl) 0;
  }
  .content {
    display: flex;
    align-items: center;
  }
  .close {
    margin-top: var(--gap);
    margin-left: var(--gap);
    text-align: left;
    background-color: var(--color-purple);
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
    margin-bottom: var(--gap);
    text-align: center;
  }
  .squids img {
    height: 180px;
  }
  ul {
    list-style: none;
    padding-left: 1em;
  }
  li:before {
    content: "\2713";
    display: inline-block;
    height: 1em;
    width: 1em;
    margin-right: 0.5em;
  }
</style>
