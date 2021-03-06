require 'spec_helper'

describe Devise::Strategies::Oauth2RefreshTokenGrantTypeStrategy do
  describe 'POST /oauth2/token' do
    describe 'with grant_type=refresh_token' do
      context 'with valid params' do
        let(:user) { create(:user) }
        let(:client) { create(:client) }
        before do
          @refresh_token = client.refresh_tokens.create! :user => user
          params = {
            :grant_type => 'refresh_token',
            :client_id => client.identifier,
            :client_secret => client.secret,
            :refresh_token => @refresh_token.token
          }

          post '/oauth2/token', params
        end
        it { response.code.to_i.should == 200 }
        it { response.content_type.should == 'application/json' }
        it "returns second time too" do 
          params = {
            :grant_type => 'refresh_token',
            :client_id => client.identifier,
            :client_secret => client.secret,
            :refresh_token => @refresh_token.token
          }
          post '/oauth2/token', params
        end
        it 'returns json' do
          token = Devise::Oauth2Providable::AccessToken.last
          refresh_token = @refresh_token
          expected = {
            :token_type => 'bearer',
            :expires_in => 899,
            :refresh_token => refresh_token.token,
            :access_token => token.token
          }
          response.body.should match_json(expected)
        end

        
      end
      context 'with expired refresh_token' do
        let(:user) { create(:user) }
        let(:client) { create(:client) }
        before do
          timenow = 2.days.from_now
          Time.stub!(:now).and_return(timenow)
          @refresh_token = client.refresh_tokens.create! :user => user
          params = {
            :grant_type => 'refresh_token',
            :client_id => client.identifier,
            :client_secret => client.secret,
            :refresh_token => @refresh_token.token
          }
          Time.stub!(:now).and_return(timenow + 2.months)

          post '/oauth2/token', params
        end
        it { response.code.to_i.should == 400 }
        it { response.content_type.should == 'application/json' }
        it 'returns json' do
          expected = {
            :error => 'invalid_grant',
            :error_description => 'invalid refresh token'
          }
          response.body.should match_json(expected)
        end
      end
      context 'with invalid refresh_token' do
        let(:user) { create(:user) }
        let(:client) { create(:client) }
        before do
          @refresh_token = client.refresh_tokens.create! :user => user
          params = {
            :grant_type => 'refresh_token',
            :client_id => client.identifier,
            :client_secret => client.secret,
            :refresh_token => 'invalid'
          }

          post '/oauth2/token', params
        end
        it { response.code.to_i.should == 400 }
        it { response.content_type.should == 'application/json' }
        it 'returns json' do
          token = Devise::Oauth2Providable::AccessToken.last
          refresh_token = @refresh_token
          expected = {
            :error => 'invalid_grant',
            :error_description => 'invalid refresh token'
          }
          response.body.should match_json(expected)
        end
      end
      context 'with invalid client_id' do
        let(:user) { create(:user) }
        let(:client) { create(:client) }
        before do
          @refresh_token = client.refresh_tokens.create! :user => user
          params = {
            :grant_type => 'refresh_token',
            :client_id => 'invalid',
            :client_secret => client.secret,
            :refresh_token => @refresh_token.token
          }

          post '/oauth2/token', params
        end
        it { response.code.to_i.should == 400 }
        it { response.content_type.should == 'application/json' }
        it 'returns json' do
          expected = {
            :error => 'invalid_client',
            :error_description => 'invalid client credentials'
          }
          response.body.should match_json(expected)
        end
      end
      context 'with invalid client_secret' do
        let(:user) { create(:user) }
        let(:client) { create(:client) }
        before do
          @refresh_token = client.refresh_tokens.create! :user => user
          params = {
            :grant_type => 'refresh_token',
            :client_id => client.identifier,
            :client_secret => 'invalid',
            :refresh_token => @refresh_token.token
          }

          post '/oauth2/token', params
        end
        it { response.code.to_i.should == 400 }
        it { response.content_type.should == 'application/json' }
        it 'returns json' do
          expected = {
            :error => 'invalid_client',
            :error_description => 'invalid client credentials'
          }
          response.body.should match_json(expected)
        end
      end
    end
  end
end

