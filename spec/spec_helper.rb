RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

def spawn_test_user(name = 'birdman')
  # This method is not used, but is retained for illustration of this method to
  # create dummy users.
  password = "ilove#{name.delete(' ').split(//).shuffle!.join}"
  salt = Authlogic::Random.hex_token

  User.create!(
    id: 1,
    login: name,
    email: "enlightened.#{name}@bhalash.com",
    nicename: "Enlightened #{name.capitalize}",
    password: password,
    password_confirmation: password,
    # Included so I can explain why these aren't used: AuthLogic creates these
    # fields itself when I spawn a user. If I attempt to create these myself 
    # AuthLogic considers the user to be invalid.
    #
    # password_salt: salt,
    # crypted_password: Authlogic::CryptoProviders::Sha512.encrypt(password + salt),
    # persistence_token: Authlogic::Random.hex_token
  )
end

def log_in_as(user)
  visit new_user_session_path

  within '#login' do
    fill_in 'user_session_login', with: user.email
    fill_in 'user_session_password', with: user.password
    click_button 'user_session_submit'
  end
end

def log_out
  visit '/logout'
end

def as_user(user)
  log_in_as user
  yield
  log_out
end
