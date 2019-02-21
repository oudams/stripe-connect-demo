class OauthAccountsController < ApplicationController
  def new
    # register the redirect URI as http://localhost:3000/oauth_accounts/new
    # capture the error description if any
    flash[:notice] = params[:error_description] if params[:error]
  end

  def create
    oauth = create_stripe_oauth(params[:oauth_account][:authorization_code])
    # oauth = create_bongloy_oauth(params[:oauth_account][:authorization_code])

    if oauth
      # @oauth_account = oauth
      @oauth_account = OauthAccount.new(oauth)

      flash[:success] = "Oauth Account is created." if @oauth_account.save
    end

    render :new
  end

  def index
    @resources = OauthAccount.order(created_at: :desc)
  end

  private

  def create_bongloy_oauth(authorization_code)
    conn = Faraday.new(url: "http://localhost:3000") do |f|
      f.request  :url_encoded
      f.adapter  Faraday.default_adapter
    end

    response = conn.post(
      "/oauth/token",
      {
        "code" => authorization_code,
        "client_id" => "lGa-PUDZY79OA-7qgJfTrORo0gpbRJd6Vv0oEBb3B1Q",
        "client_secret" => "gMCoeQCisuR7FRBtuNGaV7_vRutGgAZO3e_8T77GQfg",
        "redirect_uri" => "http://localhost:3001/oauth_accounts/new",
        "grant_type" => "authorization_code"
      }
    )

    return JSON.parse(response.body) if response.success?

    flash[:notice] = "Unable to create oauth token"
    false
  end

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
