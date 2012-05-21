require 'devise/models'

module Devise
  module Models
    module Oauth2Providable
      extend ActiveSupport::Concern
      included do
        has_many :access_tokens, class_name: Devise::Oauth2Providable::AccessToken.name
        has_many :authorization_codes, class_name: Devise::Oauth2Providable::AuthorizationCode.name
        has_many :clients, class_name: Devise::Oauth2Providable::Client.name
      end
    end
  end
end
