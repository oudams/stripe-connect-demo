Rails.application.routes.draw do
  get 'oauth_accounts/new'
  resources :charges, :only => [:new, :create]
  resources :oauth_accounts
  root :to => "oauth_accounts#new"
end
