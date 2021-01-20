<script lang="ts">
  export let saveComment: (text: string) => Promise<boolean>;

  let newCommentText: string = "";

  async function submitComment() {
    let content = newCommentText;
    let promise = saveComment(newCommentText);
    newCommentText = "";
    let successfullySaved = await promise;
    if (!successfullySaved) {
      // Saving failed, reset the text input so the user can try again
      newCommentText = content;
    }
  }

  function handleKeypress(event: KeyboardEvent) {
    if (event.ctrlKey && event.key === "Enter") {
      submitComment();
    }
  }
</script>

<div>
  <form on:submit|preventDefault={submitComment}>
    <div
      class="content"
      contenteditable
      on:keypress={handleKeypress}
      bind:textContent={newCommentText}
    />
    {#if !newCommentText}
      <input class="placeholder-button button" type="submit" value="Send" />
      <span class="placeholder">Post a comment</span>
    {/if}
    {#if newCommentText}
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
