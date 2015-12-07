RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

def spawn_test_user(name = 'birdman')
  password = "ilove#{name.delete(' ').split(//).shuffle!.join}"
  salt = Authlogic::Random.hex_token

  User.create!(
    id: 1,
    login: name,
    email: "enlightened.#{name}@bhalash.com",
    nicename: "Enlightened #{name.capitalize}",
    password: password,
    password_confirmation: password,
    # password_salt: salt,
    # crypted_password: Authlogic::CryptoProviders::Sha512.encrypt(password + salt),
    # persistence_token: Authlogic::Random.hex_token
  )
end
