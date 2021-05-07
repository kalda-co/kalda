<script lang="ts">
  export let save: (text: string) => Promise<any>;
  export let placeholder: string;
  export let focus: boolean = false;
  export let buttonText: string;
  export let level: "normal" | "warn" = "normal";

  let newContent: string = "";

  async function submitComment() {
    let content = newContent;
    let sanitisedContent = stripHtml(content);
    console.log("santisedContent:", sanitisedContent);
    try {
      newContent = "";
      await save(sanitisedContent);
    } catch (error) {
      // Saving failed, reset the text input so the user can try again
      newContent = content;
      console.error(error);
    }
  }

  // Bug, if you leave a space before a newline it prints &nbsp;
  // But if you replace all &nbsp; with ' ' it removes newline entirely!
  // This is because IF a newline input is preceeded by a space the innerhtml is
  // NOT
  // <div>"some text "</div>
  //<div>"then more"</div>
  // but:
  //<div>"some text&nbsp;"<br>"then more"</div>
  function stripHtml(html: string) {
    return (
      html
        // Swap opening divs for newlines
        .replaceAll("<div>", "\n")
        // Swap breaks for newlines
        .replaceAll("<br>", "\n")
        // Remove other HTML tags
        .replaceAll(/<[^>]+>/g, "")
        // Convert common HTML entities
        .replaceAll("&#x27;", "'")
        .replaceAll("&#x60;", "`")
        .replaceAll("&amp;", "&")
        .replaceAll("&gt;", ">")
        .replaceAll("&lt;", "<")
        .replaceAll("&quot;", '"')
        .replaceAll("&nbsp;", " ")
        // Collapse repeat newlines
        .replaceAll(/\n+/g, "\n")
    );
  }

  function handlePaste(event: ClipboardEvent) {
    let clip = event.clipboardData;
    let content =
      clip?.getData("text/html") || clip?.getData("text/plain") || "";

    // Insert the filtered content
    document.execCommand("insertHTML", false, stripHtml(content));

    // Prevent the standard paste behavior
    event.preventDefault();
  }

  function handleKeypress(event: KeyboardEvent) {
    if (event.ctrlKey && event.code === "Enter") {
      submitComment();
    }
  }

  // substitute textContent for innerText and split on nl and wrap in <p>

  function initFocus(element: HTMLElement) {
    if (focus) {
      element.focus();
    }
  }
</script>

<div>
  <form on:submit|preventDefault={submitComment} class={level}>
    <div
      class="content-input"
      contenteditable
      on:paste={handlePaste}
      on:keypress={handleKeypress}
      bind:innerHTML={newContent}
      use:initFocus
    />
    {#if !newContent}
      <input
        class="placeholder-button button"
        type="submit"
        value={buttonText}
      />
      <span class="placeholder">{placeholder}</span>
    {/if}
    {#if newContent}
      <input
        type="submit"
        class="not-placeholder-button button"
        value={buttonText}
      />
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

  .content-input {
    border: none;
    width: 100%;
    max-width: 100%;
    resize: none;
    background: rgba(0, 0, 0, 0);
  }

  .content-input:focus {
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

  .warn {
    background-color: #f8e5e5;
    margin-left: unset;
    border: 2px solid #b60000;
  }

  .warn .not-placeholder-button,
  .warn .placeholder-button {
    background-color: #b60000;
    border: 2px solid #b60000;
  }
</style>
