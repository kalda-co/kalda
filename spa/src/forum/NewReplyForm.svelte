<script lang="ts">
  import type { Reply } from "../state";
  import { scale } from "svelte/transition";

  export let reply: Reply;

  export let saveReply: (text: string) => Promise<any>;

  let newReplyText: string = "";

  async function submitReply() {
    let content = newReplyText;
    try {
      newReplyText = "";
      await saveReply(content);
    } catch (error) {
      // Saving failed, reset the text input so the user can try again
      newReplyText = content;
      console.error(error);
    }
  }

  function handleKeypress(event: KeyboardEvent) {
    if (event.ctrlKey && event.key === "Enter") {
      submitReply();
    }
  }
</script>

<div>
  <form on:submit|preventDefault={submitReply}>
    <div
      class="content"
      contenteditable
      on:keypress={handleKeypress}
      bind:textContent={newReplyText}
    />
    {#if !newReplyText}
      <input class="placeholder-button button" type="submit" value="Send" />
      <span class="placeholder">Post a reply</span>
    {/if}
    {#if newReplyText}
      <input type="submit" class="not-placeholder-button button" value="Send" />
    {/if}
  </form>
</div>

<style>
  form {
    border-radius: 30px;
    border: 2px solid var(--color-purple);
    padding: var(--gap);
    margin-bottom: var(--gap);
    position: relative;
  }

  .content {
    border: none;
    width: 100%;
    max-width: 100%;
    resize: none;
    background: rgba(0, 0, 0, 0);
  }

  .placeholder,
  .placeholder-button {
    pointer-events: none;
    position: absolute;
    top: var(--gap);
  }

  .placeholder-button {
    top: 10px;
    right: var(--gap);
  }

  .not-placeholder-button {
    margin-top: var(--gap-s);
    cursor: pointer;
  }
</style>
