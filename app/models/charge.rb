require "active_model"

class Charge
  include ActiveModel::Model

  attr_accessor :token, :connected_account

  validates :token, presence: true

  def save
    return false unless valid?

    Stripe.api_key = connected_account.access_token

    Stripe::Charge.create(
      {
        source: token,
        amount: 200000,
        currency: "USD",
        description: "New charge #{Time.zone.now}"
      },
      stripe_user_id: connected_account.stripe_user_id
    )

    true
  rescue Stripe::StripeError => e
    errors.add(:base, e.message)
    puts e.message
    false
  end
end
