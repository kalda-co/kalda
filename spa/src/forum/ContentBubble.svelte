<script lang="ts">
  import type { BubbleContent, Reaction, User } from "../state";
  import ContentTextForm from "./ContentTextForm.svelte";
  import { scale } from "svelte/transition";

  export let item: BubbleContent;
  export let report: (id: number, reason: string) => Promise<any>;
  export let reply: () => any;
  export let replyLine: boolean = false;
  export let currentUser: User;
  // TODO: change name to react or saveReact
  export let reaction: (
    id: number,
    relate: boolean,
    sendLove: boolean
  ) => Promise<Reaction>;

  let currentUserReactions = item.reactions.find(
    (reaction) => reaction.author.id === currentUser.id
  );

  let isRelated = currentUserReactions?.relate;
  let isLoved = currentUserReactions?.sendLove;

  let reporting = false;
  let thanks = false;

  async function saveReport(reporter_reason: string) {
    await report(item.id, reporter_reason);
    reporting = false;
    toggleThanks();
  }

  function insertOrUpdateReaction(
    reaction: Reaction,
    reactions: Array<Reaction>
  ) {
    let includedOwnReaction = false;
    let updatedReactions = reactions.map((existing) => {
      if (existing.author.id === reaction.author.id) {
        includedOwnReaction = true;
        return reaction;
      } else {
        return existing;
      }
    });
    if (includedOwnReaction) {
      //BUG? these return the same
      return updatedReactions;
    } else {
      return [reaction, ...updatedReactions];
    }
  }

  async function saveRelate(bool: boolean) {
    // seems to send love as false even when it is true (unless it starts as true on load)
    console.log("current user reactions", currentUserReactions);
    let hasLoved = currentUserReactions?.sendLove || false;
    // isRelated = bool;
    let ownReaction = await reaction(item.id, bool, hasLoved);
    isRelated = bool;
    console.log("saving relate", bool, "(sending love " + hasLoved + ")");
    item.reactions = insertOrUpdateReaction(ownReaction, item.reactions);
    reactionsCountText = makeReactionsCountText();
    console.log(
      "new reactions",
      item.reactions.find((reaction) => reaction.author.id === currentUser.id)
    );
  }

  async function saveLove(bool: boolean) {
    // TODO: BUG: when I send love it is sending the wrong value for relate
    // sendLove ALWAYS sends relate as false even if it is meant to be true.
    console.log("current user reactions", currentUserReactions);
    let hasRelated = currentUserReactions?.relate || false;
    let ownReaction = await reaction(item.id, hasRelated, bool);
    isLoved = bool;
    console.log("saving love", bool, "(sending relate " + hasRelated + ")");
    item.reactions = insertOrUpdateReaction(ownReaction, item.reactions);
    reactionsCountText = makeReactionsCountText();
    console.log(
      "new reactions",
      item.reactions.find((reaction) => reaction.author.id === currentUser.id)
    );
  }

  // TODO: BUG: You can only add one new react at a time!

  function toggleReporting() {
    reporting = !reporting;
  }

  function toggleThanks() {
    thanks = !thanks;
  }

  function toggleRelating() {
    if (isRelated) {
      saveRelate(false);
    } else {
      saveRelate(true);
    }
  }

  function toggleLoving() {
    // saveLove(!isLoved);
    if (isLoved) {
      saveLove(false);
    } else {
      saveLove(true);
    }
  }

  import { fly } from "svelte/transition";

  function makeReactionsCountText() {
    let loveCount = item.reactions.filter(
      (reaction) => reaction.sendLove === true
    );
    let relateCount = item.reactions.filter(
      (reaction) => reaction.relate === true
    );
    let total = loveCount.length + relateCount.length;
    return total;
    // TODO: add names of first 3, use switch to generate and X others
    // TODO: which reaction is it for image?
  }
  let reactionsCountText: number;
  $: {
    reactionsCountText = makeReactionsCountText();
  }
</script>

{#if thanks}
  <div class="sidebar">
    <div transition:fly|local class:thanks>
      <section transition:fly={{ y: 200, duration: 400 }}>
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
            <a href="/dashboard">
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
    </div>
  </div>
{/if}

<div
  transition:scale|local
  class="bubble"
  class:reporting
  class:reply-line={!reporting && replyLine}
>
  <div class="link-container">
    <button on:click|preventDefault={toggleReporting}>Report</button>
    <cite>{item.author.username}</cite>
  </div>
  <div class="bubble-content">
    {#each item.content.split(/\n/) as line}
      <p>{line}</p>
    {/each}
  </div>
  <!-- {item.content} -->

  <div class="link-container">
    <div class="button-container">
      <button
        class:reacting={isRelated}
        on:click|preventDefault={toggleRelating}>Relate</button
      >
      <button class:reacting={isLoved} on:click|preventDefault={toggleLoving}
        >Send Love</button
      >
    </div>
    <button on:click|preventDefault={reply}>Reply</button>
  </div>
  {#if reactionsCountText > 0}
    <span>
      <img
        src="/images/react-count.svg"
        alt="A send love icon and a relate icon"
      />
      {reactionsCountText}
    </span>
  {/if}
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

  .link-container > button {
    text-decoration: underline;
    font-size: var(--font-size-s);
    margin-top: var(--gap-s);
    cursor: pointer;
  }

  .link-container > cite {
    display: block;
    color: var(--color-purple);
    margin-bottom: var(--gap-s);
    font-style: normal;
    font-size: var(--font-size-s);
    font-weight: 500;
  }

  .sidebar {
    color: var(--color-white);
    display: inline-block;
    width: var(--sidebar-width);
    position: fixed;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    pointer-events: none;
    z-index: 1000;
  }

  .thanks p {
    color: var(--font-color-dark);
    padding: var(--gap-s);
  }

  .bubble-content p {
    word-wrap: break-word;
  }

  .bubble-content p:first-child {
    margin-top: 0px;
  }
  .bubble-content p:last-child {
    margin-bottom: 0px;
  }

  .thanks h1 {
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

  .button-container > button {
    border: 1px solid #4a00b0;
    box-sizing: border-box;
    border-radius: 20px;
    padding: 4px 8px;
    font-size: 0.8em;
  }
  .button-container > button.reacting {
    background-color: rgb(94, 78, 94);
  }
</style>
