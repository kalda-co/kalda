<script lang="ts">
  import type { BubbleContent, Reaction, User } from "../state";
  import type { Response } from "../backend/http";
  import ContentTextForm from "./ContentTextForm.svelte";
  import { scale } from "svelte/transition";
  import { makeReactionsCountText } from "./content-bubble";

  export let item: BubbleContent;
  export let report: (id: number, reason: string) => Promise<Response<any>>;
  export let reply: () => any;
  export let replyLine: boolean = false;
  export let currentUser: User;
  export let reaction: (
    id: number,
    relate: boolean,
    sendLove: boolean
  ) => Promise<Response<Reaction>>;

  let currentUserReactions = item.reactions.find(
    (reaction) => reaction.author.id === currentUser.id
  );

  let isRelated = currentUserReactions?.relate;
  let isLoved = currentUserReactions?.sendLove;

  let reporting = false;
  let thanks = false;

  async function saveReport(reporter_reason: string): Promise<Response<null>> {
    let response = await report(item.id, reporter_reason);
    if (response.type === "Success") {
      reporting = false;
      toggleThanks();
    }
    return response;
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
      return updatedReactions;
    } else {
      return [reaction, ...updatedReactions];
    }
  }

  // TODO: DUPE: saveRelate & saveLove
  async function saveRelate(bool: boolean) {
    let newReactions = item.reactions.find(
      (reaction) => reaction.author.id === currentUser.id
    );
    let hasLoved = newReactions?.sendLove || false;
    isRelated = bool;
    let response = await reaction(item.id, bool, hasLoved);
    if (response.type === "Success") {
      item.reactions = insertOrUpdateReaction(
        response.resource,
        item.reactions
      );
      reactionsCount = makeReactionsCount();
      reactionsCountText = makeReactionsCountText(item.reactions);
    }
  }

  // TODO: DUPE: saveRelate & saveLove
  async function saveLove(bool: boolean) {
    let newReactions = item.reactions.find(
      (reaction) => reaction.author.id === currentUser.id
    );
    let hasRelated = newReactions?.relate || false;
    isLoved = bool;
    let response = await reaction(item.id, hasRelated, bool);
    if (response.type === "Success") {
      item.reactions = insertOrUpdateReaction(
        response.resource,
        item.reactions
      );
      reactionsCount = makeReactionsCount();
      reactionsCountText = makeReactionsCountText(item.reactions);
    }
  }

  function toggleReporting() {
    reporting = !reporting;
  }

  function toggleThanks() {
    thanks = !thanks;
  }

  function toggleRelating() {
    saveRelate(!isRelated);
  }

  function toggleLoving() {
    saveLove(!isLoved);
  }

  import { fly } from "svelte/transition";

  function makeReactionsCount() {
    let loveCount = item.reactions.filter((reaction) => reaction.sendLove);
    let relateCount = item.reactions.filter((reaction) => reaction.relate);
    let total = loveCount.length + relateCount.length;
    return total;
  }

  let reactionsCount: number;
  $: {
    reactionsCount = makeReactionsCount();
  }
  let reactionsCountText: string;
  $: {
    reactionsCountText = makeReactionsCountText(item.reactions);
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
    {#each item.content.trim().split(/\n/) as line}
      <p>{line}</p>
    {/each}
  </div>
  <!-- {item.content} -->

  <div class="link-container">
    <div class="button-container">
      <button
        class:reacting={isRelated}
        on:click|preventDefault={toggleRelating}
      >
        <div class="inner-button-container">
          <img
            src="/images/relate.svg"
            alt="A relate icon shaped like a jellyfish or squid"
          />
          <div>&nbsp; Relate</div>
        </div>
      </button>
      <button class:reacting={isLoved} on:click|preventDefault={toggleLoving}>
        <div class="inner-button-container">
          <img
            class="send-love-image"
            src="/images/send-love.svg"
            alt="A send love icon shaped like a hand throwing a heart"
          />
          <div>&nbsp; Send Love</div>
        </div>
      </button>
    </div>
    <button on:click|preventDefault={reply}
      ><div id="reply-text">Reply</div></button
    >
  </div>
  {#if reactionsCount > 0}
    <span>
      <div class="reacts-container">
        <img
          src="/images/react-count.svg"
          alt="A send love icon and a relate icon"
        />
        <div class="names-container">
          <!-- <div class="count-text">{reactionsCount}</div> -->
          <div class="count-names">{reactionsCountText}</div>
        </div>
      </div>
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
    align-items: center;
    margin-bottom: var(--gap-s);
  }

  .link-container > button {
    text-decoration: underline;
    font-size: var(--font-size-s);
    cursor: pointer;
  }

  .link-container > cite {
    display: block;
    color: var(--color-purple);
    font-style: normal;
    font-size: var(--font-size);
    font-weight: 600;
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
    padding-bottom: var(--gap);
    word-wrap: break-word;
    font-weight: 500;
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
    border: 1px solid #c300be;
    box-sizing: border-box;
    border-radius: 20px;
    padding: 4px 8px;
    font-size: var(--font-size-s);
    color: #c300be;
    font-weight: 400;
  }
  .button-container > button.reacting {
    background-color: #ffb0fd;
    font-weight: 400;
  }
  .inner-button-container {
    display: flex;
    flex-direction: row;
    align-items: center;
  }
  .send-love-image {
    padding-top: 4px;
    padding-bottom: 4px;
  }
  .reacts-container {
    display: flex;
    flex-direction: row;
    align-items: center;
  }
  .names-container {
    display: flex;
    flex-direction: row;
    align-items: flex-end;
  }
  /* .count-text {
    font-size: 1.1em;
    padding-left: var(--gap-s);
    font-weight: 600;
  } */
  .count-names {
    padding-left: var(--gap-s);
    font-size: var(--font-size-s);
  }
  button #reply-text {
    /* font-size: 1.2em; */
    font-size: var(--font-size-s);
    font-weight: 600;
  }
</style>
