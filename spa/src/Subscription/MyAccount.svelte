<script lang="ts">
  import { link } from "svelte-routing";
</script>

<div class="account">
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
        <h2>Congratulations! You are subscribed. You get:</h2>
        <ul>
          <li>Weekly group mental health sessions on Zoom</li>
          <li>
            Daily reflection questions in a peer support community, here and in
            your browser
          </li>
          <li>Mindfulness recordings</li>
          <li>First access to Kalda Zoom courses and events</li>
        </ul>
        <p class="grey">
          To unsubscribe, please email subscriptions@kalda.co with the subject
          line or body 'Unsubscribe'. Make sure to send the email from the
          address you are registered with.
        </p>
      </div>
    </div>
  </div>
</div>

<style>
  .account {
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
  .squids {
    margin-bottom: var(--gap);
    text-align: center;
  }
  .squids img {
    height: 180px;
  }
  .grey {
    color: #404040;
  }
</style>
