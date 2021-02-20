<script lang="ts">
  import type { BubbleContent } from "../state";
  import ContentTextForm from "./ContentTextForm.svelte";
  import { scale } from "svelte/transition";

  export let item: BubbleContent;
  export let report: (id: number, reason: string) => Promise<any>;
  export let reply: () => any;
  export let replyLine: boolean = false;

  let reporting = false;
  let thanks = false;

  async function saveReport(reporter_reason: string) {
    await report(item.id, reporter_reason);
    reporting = false;
    toggleThanks();
  }

  function toggleReporting() {
    reporting = !reporting;
    // toggleThanks();
  }

  function toggleThanks() {
    thanks = !thanks;
  }

  import { fly } from "svelte/transition";
</script>

<div class="sidebar">
  <div transition:fly|local class:thanks>
    {#if thanks}
      <section transition:fly={{ y: 200, duration: 1000 }}>
        <button on:click|preventDefault={toggleThanks}>
          <img
            src="/images/cross-purple.svg"
            alt="close menu cross"
            class="cross-top"
          />
        </button>
        <div class="container">
          <div class="content">
            <h1>Thank you for your report</h1>
            <p>
              This content has been flagged for the attention of a moderator.
            </p>
            <p>
              Thank you for keeping the community a safe and respectful space.
            </p>
            <a href="/app">
              <button class="button">Back to community</button>
            </a>
          </div>
          <button on:click|preventDefault={toggleThanks}>
            <img
              src="/images/cross-purple.svg"
              alt="close menu cross"
              class="cross"
            />
          </button>
        </div>
      </section>
    {/if}
  </div>
</div>

<div
  transition:scale|local
  class="bubble"
  class:reporting
  class:reply-line={!reporting && replyLine}
>
  <cite>{item.author.username}</cite>
  {item.content}

  <div class="link-container">
    <button on:click|preventDefault={toggleReporting}>Report</button>
    <button on:click|preventDefault={reply}>Reply</button>
  </div>
</div>

{#if reporting}
  <ContentTextForm
    focus={true}
    level="warn"
    placeholder="Tell us what's wrong"
    buttonText="Report"
    save={saveReport}
  />
{/if}

<style>
  .bubble {
    background-color: var(--color-grey);
    border-radius: 20px;
    padding: var(--gap);
    margin-bottom: var(--gap-s);
    position: relative;
  }

  .reply-line::after {
    --border: 2px solid var(--color-grey);
    content: "";
    position: absolute;
    border-left: var(--border);
    border-bottom: var(--border);
    border-radius: 20px;
    bottom: calc(-1 * var(--gap-l) - var(--gap-s));
    left: 0;
    top: 0;
    right: 0;
    pointer-events: none;
  }

  cite {
    display: block;
    color: var(--color-purple);
    margin-bottom: var(--gap-s);
    font-style: normal;
    font-size: var(--font-size-s);
    font-weight: 500;
  }

  .reporting {
    background-color: #f8e5e5;
    border: 2px solid #b60000;
    padding: calc(var(--gap) - 2px);
  }

  .link-container {
    display: flex;
    justify-content: space-between;
    flex-direction: row-reverse;
  }

  .link-container > * {
    text-decoration: underline;
    font-size: var(--font-size-s);
    margin-top: var(--gap-s);
    cursor: pointer;
  }

  .sidebar {
    color: var(--color-white);
    display: inline-block;
    width: var(--sidebar-width);
    position: fixed;
    top: 0;
    z-index: 3;
    width: 375px;
    pointer-events: none;
  }

  p {
    color: var(--font-color-dark);
    padding: var(--gap-s);
  }

  h1 {
    font-weight: 600;
    font-size: 24px;
    line-height: 32px;
    color: var(--color-purple);
  }

  section {
    width: 100%;
    background-color: var(--color-white);
    display: inline-block;
  }

  .thanks {
    pointer-events: all;
    height: 100vh;
  }

  .container {
    display: flex;
    justify-content: center;
  }

  .content {
    margin-top: 0vh;
    margin-bottom: 50vh;
    width: 375px;
    height: 50vh;
    display: flex;
    justify-content: space-around;
    flex-wrap: wrap;
  }

  .button {
    color: var(--color-white);
    background-color: var(--color-purple);
    margin: var(--gap);
    text-align: center;
    white-space: nowrap;
    padding: var(--gap);
  }

  .cross {
    position: absolute;
    bottom: 0;
    right: 0;
    margin: var(--gap-s);
  }
  .cross-top {
    top: 0;
    right: 0;
    margin: var(--gap-s);
    position: absolute;
  }
</style>
