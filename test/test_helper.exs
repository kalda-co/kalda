ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Kalda.Repo, :manual)
Logger.remove_backend(:console)

Hammox.defmock(Kalda.MockStripe, for: Kalda.Payments.Stripe.Interface)
