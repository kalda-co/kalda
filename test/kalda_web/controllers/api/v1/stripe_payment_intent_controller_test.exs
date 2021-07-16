defmodule KaldaWeb.Api.V1.StripePaymentIntentControllerTest do
  use KaldaWeb.ConnCase

  alias Kalda.Payments.Stripe.Customer
  alias Kalda.Payments.Stripe.Subscription

  setup ctx do
    Hammox.verify_on_exit!(ctx)
  end

  describe "unauthenticated requests" do
    test "POST create", ctx do
      assert ctx.conn |> post("/v1/posts/1/comments") |> json_response(401)
    end
  end

  describe "POST create" do
    setup [:register_and_log_in_user]

    test "201", %{conn: conn, user: user} do
      customer = %Customer{
        stripe_id: "1",
        subscription: nil
      }

      subscription = %Subscription{stripe_id: "2", payment_intent_client_secret: "3"}

      Kalda.MockStripe
      |> Hammox.expect(:create_customer!, 1, fn _ -> customer end)
      |> Hammox.expect(:create_subscription!, 1, fn _ -> subscription end)

      conn =
        conn
        |> Plug.Conn.assign(:stripe, Kalda.MockStripe)
        |> post("/v1/stripe-payment-intent")

      assert json_response(conn, 201) == %{
               "client_secret" => subscription.payment_intent_client_secret
             }

      assert Kalda.Accounts.get_user!(user.id).stripe_customer_id == customer.stripe_id
    end
  end
end
