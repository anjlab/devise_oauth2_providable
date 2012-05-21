require 'spec_helper'

describe Devise::Oauth2Providable::AuthorizationsController do
  before(:each) { @routes = Devise::Oauth2Providable::Engine.routes }
  describe 'routing' do
    it 'routes POST /oauth2/authorizations' do
      post('/authorizations').should route_to('devise/oauth2_providable/authorizations#create', format: 'json')
    end
    it 'routes GET /oauth2/authorize' do
      get('/authorize').should route_to('devise/oauth2_providable/authorizations#new', format: 'json')
    end
    it 'routes POST /oauth2/authorize' do
      #FIXME: this is valid, but the route is not being loaded into the test
      post('/authorize').should route_to('devise/oauth2_providable/authorizations#new', format: 'json')
    end
  end
end
