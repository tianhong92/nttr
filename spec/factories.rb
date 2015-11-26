FactoryGirl.define do
  factory :user do
    password_str = 'squidloverhothot'
    salt = Authlogic::Random.hex_token

    id 1  
    login 'squid'
    email 'squidlover@bhalash.com'
    nicename 'Squid Lover'

    password password_str 
    password_confirmation password_str 
    
    password_salt salt 
    persistence_token Authlogic::Random.hex_token
    crypted_password Authlogic::CryptoProviders::Sha512.encrypt(password_str + salt)
  end
end
