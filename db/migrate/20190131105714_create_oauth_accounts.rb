class CreateOauthAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :oauth_accounts do |t|
      t.string :access_token
      t.boolean :livemode
      t.string :refresh_token
      t.string :token_type
      t.string :stripe_publishable_key
      t.string :stripe_user_id
      t.string :scope

      t.timestamps
    end
  end
end
