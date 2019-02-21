class ChargesController < ApplicationController
  helper_method :charge, :connected_account

  def new; end

  def create
    @charge = Charge.new(token: params["new_charge"]["token"], connected_account: connected_account)

    if @charge.save
      redirect_to(
        new_charge_path,
        flash: { success: "Your Charge was successfully created! You can view it on your #{view_context.link_to("Dashboard", "https://dashboard.stripe.com/test/payments", target: "_blank")}" }
      )
    else
      render :new
    end
  end

  private

  def charge
    @charge ||= Charge.new
  end

  def resource
    charge
  end

  def connected_account
    @connected_account = OauthAccount.order(:created_at).last
  end
end
