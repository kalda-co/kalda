<script lang="ts">
  import type { BubbleContent } from "../state";
  import ContentTextForm from "./ContentTextForm.svelte";
  import { scale } from "svelte/transition";

  export let item: BubbleContent;
  export let report: (id: number, reason: string) => Promise<any>;
  export let reply: () => any;
  export let replyLine: boolean = false;

  let reporting = false;

  async function saveReport(reporter_reason: string) {
    await report(item.id, reporter_reason);
    reporting = false;
  }

  function toggleReporting() {
    reporting = !reporting;
  }
</script>

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
</style>
