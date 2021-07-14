ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Kalda.Repo, :manual)

Hammox.defmock(Kalda.MockStripe, for: Kalda.Payments.Stripe.ClientInterface)
