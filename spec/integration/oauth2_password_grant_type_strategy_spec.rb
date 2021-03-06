require 'spec_helper'

describe Devise::Strategies::Oauth2PasswordGrantTypeStrategy do
  describe 'POST /oauth2/token' do
    describe 'with grant_type=password' do
      context 'with valid params' do
        let(:client) { create(:client) }
        before do
          @user = create(:user)

          params = {
            :grant_type => 'password',
            :client_id => client.identifier,
            :client_secret => client.secret,
            :username => @user.email,
            :password => 'test123456'
          }

          post '/oauth2/token', params
        end
        it { response.code.to_i.should == 200 }
        it { response.content_type.should == 'application/json' }
        it 'returns json' do
          token = Devise::Oauth2Providable::AccessToken.last
          expected = token.token_response
          response.body.should match_json(expected)
        end
      end
      context 'with valid params and client id/secret in basic auth header' do
        let(:client) { create(:client) }
        before do
          @user = create :user

          params = {
            :grant_type => 'password',
            :username => @user.email,
            :password => 'test123456'
          }

          auth_header = ActionController::HttpAuthentication::Basic.encode_credentials client.identifier, client.secret
          post '/oauth2/token', params, 'HTTP_AUTHORIZATION' => auth_header
        end
        it { response.code.to_i.should == 200 }
        it { response.content_type.should == 'application/json' }
        it 'returns json' do
          token = Devise::Oauth2Providable::AccessToken.last
          expected = token.token_response
          response.body.should match_json(expected)
        end
      end
      context 'with invalid client id in basic auth header' do
        let(:client) { create(:client) }
        before do
          @user = create :user
          params = {
            :grant_type => 'password',
            :username => @user.email,
            :password => 'test123456'
          }
          auth_header = ActionController::HttpAuthentication::Basic.encode_credentials 'invalid client id', client.secret
          post '/oauth2/token', params, 'HTTP_AUTHORIZATION' => auth_header
        end
        it { response.code.to_i.should == 400 }
        it { response.content_type.should == 'application/json'  }
        it 'returns json' do
          expected = {
            :error_description => "invalid client credentials",
            :error => "invalid_client"
          }
          response.body.should match_json(expected)
        end
      end
      context 'with invalid client secret in basic auth header' do
        let(:client) { create(:client) }
        before do
          @user = create :user
          params = {
            :grant_type => 'password',
            :username => @user.email,
            :password => 'test123456'
          }
          auth_header = ActionController::HttpAuthentication::Basic.encode_credentials client.identifier, 'invalid secret'
          post '/oauth2/token', params, 'HTTP_AUTHORIZATION' => auth_header
        end
        it { response.code.to_i.should == 400 }
        it { response.content_type.should == 'application/json'  }
        it 'returns json' do
          expected = {
            :error_description => "invalid client credentials",
            :error => "invalid_client"
          }
          response.body.should match_json(expected)
        end
      end
      context 'with invalid password' do
        let(:client) { create(:client) }
        before do
          @user = create :user

          params = {
            :grant_type => 'password',
            :client_id => client.identifier,
            :client_secret => client.secret,
            :username => @user.email,
            :password => 'bar'
          }

          post '/oauth2/token', params
        end
        it { response.code.to_i.should == 400 }
        it { response.content_type.should == 'application/json'  }
        it 'returns json' do
          expected = {
            :error_description => "invalid password authentication request",
            :error => "invalid_grant"
          }
          response.body.should match_json(expected)
        end
      end
      context 'with invalid user' do
        let(:client) { create(:client) }
        before do
          @user = create :user

          params = {
            :grant_type => 'password',
            :client_id => client.identifier,
            :client_secret => client.secret,
            :username => 'bla@bla.com',
            :password => 'bar'
          }

          post '/oauth2/token', params
        end
        it { response.code.to_i.should == 400 }
        it { response.content_type.should == 'application/json'  }
        it 'returns json' do
          expected = {
            :error_description => "invalid password authentication request",
            :error => "invalid_grant"
          }
          response.body.should match_json(expected)
        end
      end
      context 'with invalid client_id' do
        let(:client) { create(:client) }
        before do
          @user = create :user

          params = {
            :grant_type => 'password',
            :client_id => 'invalid',
            :client_secret => client.secret,
            :username => @user.email,
            :password => 'test123456'
          }

          post '/oauth2/token', params
        end
        it { response.code.to_i.should == 400 }
        it { response.content_type.should == 'application/json'  }
        it 'returns json' do
          expected = {
            :error_description => "invalid client credentials",
            :error => "invalid_client"
          }
          response.body.should match_json(expected)
        end
      end
      context 'with invalid client_secret' do
        let(:client) { create(:client) }
        before do
          @user = create :user

          params = {
            :grant_type => 'password',
            :client_id => client.identifier,
            :client_secret => 'invalid',
            :username => @user.email,
            :password => 'test123456'
          }

          post '/oauth2/token', params
        end
        it { response.code.to_i.should == 400 }
        it { response.content_type.should == 'application/json'  }
        it 'returns json' do
          expected = {
            :error_description => "invalid client credentials",
            :error => "invalid_client"
          }
          response.body.should match_json(expected)
        end
      end
    end
  end
end

