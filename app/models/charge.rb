require "active_model"

class Charge
  include ActiveModel::Model

  attr_accessor :token, :amount, :currency, :description, :stripe_user_id

  validates :amount, :token, presence: true

  def save
    return false unless valid?

    process_charge
  end

  private

  def process_charge
    charge_params = build_charge_params

    Stripe.api_key = "sk_test_pBEUAICiRZ9HJGxVcYULIAPy"
    Stripe::Charge.create(charge_params, stripe_user_id: stripe_user_id)

    true
  rescue Stripe::StripeError => e
    errors.add(:base, e.message)
    puts e.message
    false
  end

  def build_charge_params
    result = { amount: amount_in_cents, currency: "USD", source: token, description: "New charge #{Time.zone.now}" }

    # result.merge(stripe_account: stripe_user_id) if stripe_user_id

    result
  end

  def amount_in_cents
    (amount.to_f * 100).to_i
  end
end
