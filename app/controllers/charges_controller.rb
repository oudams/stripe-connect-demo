class ChargesController < ApplicationController
  helper_method :charge

  def new; end

  def create
    @charge = Charge.new(permitted_params[:new_charge])

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

  def permitted_params
    params.permit(new_charge: %i[token amount])
  end

  def resource
    charge
  end
end
