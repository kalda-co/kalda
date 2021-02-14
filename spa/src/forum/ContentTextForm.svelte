<script lang="ts">
  export let save: (text: string) => Promise<any>;
  export let placeholder: string;
  export let focus: boolean = false;

  let newContent: string = "";

  async function submitComment() {
    let content = newContent;
    try {
      newContent = "";
      await save(content);
    } catch (error) {
      // Saving failed, reset the text input so the user can try again
      newContent = content;
      console.error(error);
    }
  }

  function handleKeypress(event: KeyboardEvent) {
    if (event.ctrlKey && event.key === "Enter") {
      submitComment();
    }
  }

  function initFocus(element: HTMLElement) {
    if (focus) {
      element.focus();
    }
  }
</script>

<div>
  <form on:submit|preventDefault={submitComment}>
    <div
      class="content"
      contenteditable
      on:keypress={handleKeypress}
      bind:textContent={newContent}
      use:initFocus
    />
    {#if !newContent}
      <input class="placeholder-button button" type="submit" value="Send" />
      <span class="placeholder">{placeholder}</span>
    {/if}
    {#if newContent}
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
    background-color: var(--color-white);
  }

  /* TODO: indicate focus somehow */
  /* form:focus-within {} */

  .content {
    border: none;
    width: 100%;
    max-width: 100%;
    resize: none;
    background: rgba(0, 0, 0, 0);
  }

  .content:focus {
    outline: none;
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
