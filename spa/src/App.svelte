<script lang="ts">
  import Authenticated from "./Authenticated.svelte";
  import { AuthenticatedApiClient, login } from "./backend";

  export let apiBase: string;

  // TODO: loac token from storage
  let apiToken: string | undefined;

  let email = "";
  let password = "";
  let error = "";
  let submitting = false;

  // TODO: preserve token in storage
  async function submit() {
    if (submitting) return;
    submitting = true;
    error = "";
    let result = await login(email, password);
    submitting = false;
    if (result.type === "ok") {
      apiToken = result.apiToken;
    } else {
      error = result.errorMessage;
    }
  }
</script>

<!-- If we have a csrfToken we must be logged in -->
{#if apiToken}
  <Authenticated api={new AuthenticatedApiClient(apiBase, apiToken)} />
{:else}
  <div class="login-container">
    <h1>Hi! If you have an account, you can log in:</h1>

    {#if error}
      <div class="alert alert-danger">
        <p>{error}</p>
      </div>
    {/if}

    <form on:submit|preventDefault={submit}>
      <label for="email">Email</label>
      <input
        type="email"
        name="email"
        required
        disabled={submitting}
        bind:value={email}
      />

      <label for="password">Password</label>
      <input
        name="password"
        type="password"
        required
        disabled={submitting}
        bind:value={password}
      />
      <div>
        <button type="submit" disabled={submitting} class="submit-button">
          Log in
        </button>
      </div>
    </form>
  </div>
{/if}

<style>
  /* Styles copied from app.css. Should probably go somewhere else to avoid so
   * much duplication? */

  .login-container {
    margin: auto;
    display: block;
    max-width: 536px;
    letter-spacing: -0.02rem;
    padding: var(--gap);
  }

  input {
    margin-right: var(--gap-s);
    border-radius: 100px;
    border: 2px solid var(--color-purple);
    padding: var(--button-padding);
    width: 100%;
  }

  label {
    font-weight: var(--font-weight-large);
    font-size: var(--font-size-l);
    color: var(--color-purple);
  }

  .submit-button {
    background-color: var(--color-purple);
    color: var(--color-white);
    border: none;
    padding: var(--gap) var(--gap-m);
    font-weight: 600;
    border-radius: 100px;
    font-size: var(--font-size-s);
    text-decoration: none;
    margin-top: var(--gap);
    cursor: pointer;
  }

  h1 {
    font-size: var(--font-size-xl);
    line-height: var(--line-height-l);
    font-weight: var(--font-weight-large);
    color: var(--color-purple);
  }
</style>
