<script>
  import type { Stripe } from "../stripe";
  import type { StripeCardElementChangeEvent } from "@stripe/stripe-js";
  import type { StripePaymentIntent } from "../state";
  import { onMount, onDestroy } from "svelte";
  import { UnmatchedError } from "../exhaustive";
  import * as log from "../log";
  export let stripe: Stripe;
  export let paymentIntent: StripePaymentIntent;
  export let success: () => void;
  export let failure: () => void;
  const STRIPE_ELEMENT_ID = "stripe-card-element";
  let error = "";
  let elements = stripe.elements();
  let card = elements.create("card", { hidePostalCode: false });
  card.on("change", (event: StripeCardElementChangeEvent) => {
    error = event.error?.message || "";
  });
  onMount(() => {
    card.mount("#" + STRIPE_ELEMENT_ID);
  });
  onDestroy(() => {
    card.destroy();
  });
  async function submit() {
    log.info("Attempting Stripe payment");
    let result = await stripe.confirmCardPayment(paymentIntent.clientSecret, {
      payment_method: {
        card,
        billing_details: {},
      },
    });
    // https://github.com/stripe/stripe-js/blob/c1527dad47203d099e978b4650072edcc855b2b0/types/stripe-js/index.d.ts
    let type = result.error?.type;
    switch (type) {
      case undefined:
        log.info("Stripe Payment success");
        success();
        return;
      case "api_connection_error":
      case "api_error":
      case "authentication_error":
      case "card_error":
      case "idempotency_error":
      case "invalid_request_error":
      case "rate_limit_error":
      case "validation_error":
        log.error("Stripe Payment failure: ", type, result.error?.message);
        failure();
        return;
      default:
        throw new UnmatchedError(type);
    }
  }
</script>

<!-- TODO: close button to exit this screen -->
<form on:submit|preventDefault={submit}>
  <label for={STRIPE_ELEMENT_ID}>Card</label>
  <div id={STRIPE_ELEMENT_ID} class="card-inputs" />
  <div id="card-element-errors" role="alert">{error}</div>
  <button class="button" type="submit">Subscribe</button>
</form>

<style>
  button {
    display: block;
    width: 100%;
  }
  .card-inputs {
    margin: var(--gap-s) 0 var(--gap) 0;
  }
</style>
