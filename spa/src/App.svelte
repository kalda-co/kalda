<script lang="ts">
  import Authenticated from "./Authenticated.svelte";
  import { AuthenticatedApiClient, login } from "./backend";
  import { loadApiToken, saveApiToken, deleteApiToken } from "./local-storage";
  import { cancelDailyReflectionNotifications } from "./local-notification";
  import { setStatusBarColor } from "./device";
  import { KALDA_PURPLE } from "./constants";
  import { alertbox } from "./dialog";
  import type { ErrorHandlers } from "./backend/http";

  export let apiBase: string;

  let apiToken: string | undefined;
  let email = "";
  let password = "";
  let loginError = "";
  let submitting = false;

  loadApiToken().then((token) => {
    apiToken = token;
  });

  setStatusBarColor(KALDA_PURPLE);

  async function submitLoginForm() {
    if (submitting) return;
    submitting = true;
    loginError = "";
    let result = await login(apiBase, email, password);
    submitting = false;
    if (result.type === "ok") {
      apiToken = result.apiToken;
      saveApiToken(apiToken);
    } else {
      loginError = result.errorMessage;
    }
  }

  function authFailed() {
    deleteApiToken();
    cancelDailyReflectionNotifications();
    alertbox(
      "Authentication needed",
      "Your session has expired, please log in again"
    );
    apiToken = undefined;
  }

  function serverError() {
    // TODO: register exception with tracker
    alertbox(
      "Server error",
      "An unexpected server error occurred. Please try again later"
    );
  }

  function networkError() {
    alertbox(
      "Connection problems",
      "We couldn't reach our servers right now. Please try again later"
    );
  }

  function unexpectedBody() {
    // TODO: register exception with tracker
    alertbox(
      "Unexpected response",
      "We got an unexpected response from our servers. Please try again later"
    );
  }

  function unexpectedStatus() {
    // TODO: register exception with tracker
    alertbox(
      "Unexpected status",
      "We got an unexpected status from our servers. Please try again later"
    );
  }

  let errorHandlers: ErrorHandlers = {
    authFailed,
    serverError,
    networkError,
    unexpectedBody,
    unexpectedStatus,
  };
</script>

<!-- If we have an API token we must be logged in -->
{#if apiToken}
  <Authenticated
    api={new AuthenticatedApiClient(apiBase, apiToken, errorHandlers)}
  />
{:else}
  <div class="login-container">
    <h1>Hi! If you have an account, you can log in:</h1>

    {#if loginError}
      <div class="alert alert-danger">
        <p>{loginError}</p>
      </div>
    {/if}

    <form on:submit|preventDefault={submitLoginForm}>
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

    <p class="forgot-password">
      <a href="https://kalda.co/users/reset-password">Forgot your password?</a>
    </p>
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

  .forgot-password {
    font-weight: var(--font-weight-large);
    color: unset;
  }
</style>
