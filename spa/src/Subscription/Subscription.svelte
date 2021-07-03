<script>
  import type { Stripe } from "../stripe";
  import Loading from "../Loading.svelte";
  import Offer from "./Offer.svelte";
  import PaymentForm from "./PaymentForm.svelte";

  export let stripe: Stripe;

  let paymentIntentSecret: Promise<string> = Promise.resolve(""); // TODO
  let purchasing = false;
</script>

{#if purchasing}
  {#await paymentIntentSecret}
    <Loading />
  {:then paymentIntentSecret}
    <PaymentForm {stripe} {paymentIntentSecret} />
  {/await}
{:else}
  <Offer buttonClicked={() => (purchasing = true)} />
{/if}

<style>
</style>
