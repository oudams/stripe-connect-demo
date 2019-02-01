class OauthAccountsController < ApplicationController
  def new; end

  def create
    stripe_oauth = create_stripe_oauth(params[:oauth_account][:authorization_code])

    if stripe_oauth
      @oauth_account = OauthAccount.new(stripe_oauth)

      binding.pry
      flash[:success] = "Oauth Account is created." if @oauth_account.save
    end

    render :new
  end

  private

  def create_stripe_oauth(authorization_code)
    conn = Faraday.new(url: "https://connect.stripe.com") do |f|
      f.request  :url_encoded
      f.adapter  Faraday.default_adapter
    end

    response = conn.post(
      "/oauth/token",
      {
        "client_secret" => "sk_test_9xQFJPn2CXKsIDJ3SP3QU3UW",
        "code" => authorization_code,
        "grant_type" => "authorization_code"
      }
    )

    return JSON.parse(response.body) if response.success?

    flash[:notice] = "Unable to create oauth token"
    false
  end

  def resource
    @oauth_account ||= OauthAccount.new
  end
end
