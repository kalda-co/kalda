<script>
  import type { StripePaymentIntent } from "../state";
  import type { Stripe } from "../stripe";
  import Loading from "../Loading.svelte";
  import Offer from "./Offer.svelte";
  import PaymentForm from "./PaymentForm.svelte";
  import type { ApiClient } from "../backend";

  export let stripe: Stripe;
  export let api: ApiClient;

  type Stage = "displayingOffer" | "purchasing" | "success" | "failure";

  let stage: Stage = "displayingOffer";

  function to(newStage: Stage): () => void {
    return () => (stage = newStage);
  }
  let paymentIntent: Promise<StripePaymentIntent> = api
    .getStripePaymentIntent()
    .then((res) => {
      if (res.type === "Success") {
        return res.resource;
      } else {
        throw res;
      }
    });

  function refresh(): void {
    window.location.pathname = "/app";
  }
</script>

{#if stage === "purchasing"}
  {#await paymentIntent}
    <Loading />
  {:then paymentIntent}
    <div class="content">
      <button class="button-close" on:click|preventDefault={refresh}>
        <img src="/images/cross-purple.svg" alt="close menu cross" />
      </button>
      <h1>Upgrade to premium</h1>
      <p>
        Total due now £2.99. You will be billed £2.99 each month. You can cancel
        any time.
      </p>

      <PaymentForm
        {stripe}
        {paymentIntent}
        success={to("success")}
        failure={to("failure")}
      />
    </div>
  {/await}
{:else if stage === "success"}
  <div class="content">
    <button class="button-close" on:click|preventDefault={refresh}>
      <img src="/images/cross-purple.svg" alt="close menu cross" />
    </button>
    <h1>Welcome to Kalda premium!</h1>
    <p>
      Your subscription was successful. You will be billed £2.99 each month. You
      can cancel any time, just email subscriptions@kalda.co
    </p>
  </div>
{:else if stage === "failure"}
  <div class="content">
    <a href="/app" class="close">×</a>
    <h1>There was a problem processing your payment</h1>
    <p>Please try again later.</p>
  </div>
{:else}
  <Offer buttonClicked={to("purchasing")} />
{/if}

<style>
  h1 {
    color: var(--color-purple);
  }
  .close {
    font-size: 2.5rem;
  }
  .button-close {
    text-align: left;
  }
  .content {
    padding-top: var(--gap);
  }
</style>
