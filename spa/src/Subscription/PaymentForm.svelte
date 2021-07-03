<script>
  import type { Stripe } from "../stripe";
  import { onMount, onDestroy } from "svelte";
  import { UnmatchedError } from "../exhaustive";

  export let stripe: Stripe;
  export let paymentIntentSecret: string;

  const STRIPE_ELEMENT_ID = "stripe-card-element";

  let error = "";
  let elements = stripe.elements();
  let card = elements.create("card", { hidePostalCode: false });

  card.on("change", (event) => {
    error = event.error?.message || "";
  });

  onMount(() => {
    card.mount("#" + STRIPE_ELEMENT_ID);
  });

  onDestroy(() => {
    card.destroy();
  });

  async function submit() {
    let result = await stripe.confirmCardPayment(paymentIntentSecret, {
      receipt_email: "todo", // TODO
      payment_method: {
        card,
        billing_details: {},
      },
    });

    // https://github.com/stripe/stripe-js/blob/c1527dad47203d099e978b4650072edcc855b2b0/types/stripe-js/index.d.ts
    let type = result.error?.type;
    switch (type) {
      case undefined:
        // TODO: success
        break;

      // TODO: errors
      case "api_connection_error":
      case "api_error":
      case "authentication_error":
      case "card_error":
      case "idempotency_error":
      case "invalid_request_error":
      case "rate_limit_error":
      case "validation_error":
        break;

      default:
        throw new UnmatchedError(type);
    }
  }
</script>

<!-- TODO: close button to exit this screen -->

<div class="payment">
  <form class="content">
    <label for={STRIPE_ELEMENT_ID}>Card</label>
    <div id={STRIPE_ELEMENT_ID} />
    <div id="card-element-errors" role="alert">{error}</div>
    <button type="submit" on:submit|preventDefault={submit}>Subscribe</button>
  </form>
</div>

<style>
  .payment {
    background-color: var(--color-purple);
    padding: var(--gap) 0;
  }

  form {
    background-color: var(--color-white);
  }
</style>
