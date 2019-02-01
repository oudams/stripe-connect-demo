require 'test_helper'

class OauthAccountsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get oauth_accounts_new_url
    assert_response :success
  end

end
