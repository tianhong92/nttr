RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

def login_as_user(user)
  session = UserSession.create login: user.login, password: user.password
  session.save 
  session
end

def test_as_user
  @user = FactoryGirl.build :user
  @session = login_as_user @user
  yield
end
