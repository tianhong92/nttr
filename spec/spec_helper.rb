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

def spawn_test_user(name = 'birdman')
  password = "ilove#{name.delete(' ').split(//).shuffle!.join}"

  User.create!(
    id: '1',
    login: name,
    email: "enlightened.#{name}@bhalash.com",
    nicename: "Enlightened #{name.capitalize}",
    password: password,
    password_confirmation: password 
  )
end
