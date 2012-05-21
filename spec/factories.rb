FactoryGirl.define do

  sequence :email do |n|
    "person#{n}@example.com"
  end
  
  factory :user do |f|
    email
    f.password 'test123456'
  end

  factory :client, :class => 'Devise::Oauth2Providable::Client' do |f|
    f.name 'test'
    f.website 'http://localhost'
    f.redirect_uri 'http://localhost:3000'
    user
  end

end