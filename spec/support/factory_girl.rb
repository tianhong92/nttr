RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

class Test::Unit::TestCase
  include FactoryGirl::Syntax::Methods
end

def login_user(test_user)
    within '#login' do
      fill_in 'Username or email', with: test_user.email
      fill_in 'Password', with: test_user.password
      click_button 'Log in'
    end
end
