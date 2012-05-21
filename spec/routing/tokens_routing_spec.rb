require 'spec_helper'

describe Devise::Oauth2Providable::TokensController do
  before(:each) { @routes = Devise::Oauth2Providable::Engine.routes }

  describe 'routing' do
    it 'routes POST /oauth2/token' do
      post('/token').should route_to('devise/oauth2_providable/tokens#create', format: "json")
    end
  end
end
