FactoryGirl.define do
  factory :user do
    password = 'squidloverhothot'

    id 1
    login 'squid'
    email 'squidlover@example.com'
    nicename 'Squid Lover'
    password password
    password_confirmation password

    # Included so I can explain why these aren't used: AuthLogic creates these
    # fields itself when I spawn a user. If I attempt to create these myself 
    # AuthLogic considers the user to be invalid.
    
    # salt = Authlogic::Random.hex_token
    # password_salt salt 
    # persistence_token Authlogic::Random.hex_token
    # crypted_password Authlogic::CryptoProviders::Sha512.encrypt(password_str + salt)
  end
end
