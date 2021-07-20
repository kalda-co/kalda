import { loadStripe as libraryLoadStripe } from "@stripe/stripe-js";
import type { Stripe } from "@stripe/stripe-js";
export type { Stripe };

export async function loadStripe(
  stripePublishableKey: string
): Promise<Stripe> {
  let stripe = await libraryLoadStripe(stripePublishableKey);
  if (stripe === null) {
    throw new Error("Stripe was not present. This should not be possible");
  } else {
    return stripe;
  }
}
