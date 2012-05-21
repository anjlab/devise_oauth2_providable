Devise::Oauth2Providable::Engine.routes.draw do
  scope defaults: {format: 'json'} do
    root :to => "authorizations#new"

    resources :authorizations, :only => :create
    match 'authorize' => 'authorizations#new'
    resource :token, :only => :create
  end
end
