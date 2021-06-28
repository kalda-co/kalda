<script>
  import type { Stripe } from "./stripe";
  import Offer from "./Subscription/Offer.svelte";
  import PaymentForm from "./Subscription/PaymentForm.svelte";

  export let stripe: Stripe;

  let purchasing = false;
</script>

{#if purchasing}
  <PaymentForm {stripe} />
{:else}
  <Offer buttonClicked={() => (purchasing = true)} />
{/if}

<style>
</style>
