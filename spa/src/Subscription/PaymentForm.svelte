<script>
  import type { Stripe } from "../stripe";
  import { onMount, onDestroy } from "svelte";

  export let stripe: Stripe;

  const STRIPE_ELEMENT_ID = "stripe-card-element";

  let elements = stripe.elements();
  let card = elements.create("card", {});

  onMount(() => {
    card.mount("#" + STRIPE_ELEMENT_ID);
  });

  onDestroy(() => {
    card.destroy();
  });
</script>

<div class="payment">
  <form class="content">
    <div id={STRIPE_ELEMENT_ID} />
    <div id="card-element-errors" role="alert" />
    <button type="submit">Subscribe</button>
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
