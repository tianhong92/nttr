require 'spec_helper'
require 'rails_helper'

describe 'When viewing Nttr' do
  # RSpec has test syntax. Capybara only extends this to web page features.
  # Cheat sheet for Capybara expect and general syntax: 
  # Link: https://gist.github.com/zhengjia/428105
  
  # General RSpec expect:
  # Link: https://github.com/rspec/rspec-expectations

  describe 'open the front page' do
    before(:each) do 
      # Perform this action before /each/ test. In this case, it is
      # to open the application's root URL.
      #
      # Link: https://goo.gl/fo5j4j
      #
      # There exists:
      #
      #   after_([:each, :all, :suite])  
      #   before_([:each, :all, :suite])
      visit root_url
    end

    describe 'examine content' do
      # Nested tests.
      
      it 'and find the welcome title' do
        within '#welcome' do
          # Within specifies a CSS3 selector.
          expect(page).to have_content 'Welcome to nttr.'
        end
      end

      it 'and find the login form' do
        expect(page).to have_content 'Remember me'
      end

      # Will be flagged as PENDING: Not yet implemented
      it 'and find the registration form'

      it 'should have ponies' do
        # Deliberate failing test.
        within('#register') do
          expect(page).to have_content 'PONIES'
        end
      end
    end

    describe 'examine CSS' do
      # Nested tests - examine CSS.
    
      it do 
        # If the label is blank, one is generated. This outputs:
        # should have css ".container"
        expect(page).to have_css('.container', 'margin-right: auto')
      end
    end
  end
end

context 'When testing Nttr login' do
  # Think of it in terms of plain language: You /describe/ a set of tests, you
  # /give context/ for a set of tests.
  #
  # Setup can only be called from the top of a context or describe block.
  # See: spec/rails_helper.rb for how AuthLogic was initialized.
  setup :activate_authlogic 

  let(:test_user) do
    # See: https://goo.gl/9UzXG6
    #
    # The difference between before() and let() is that before() is called once, 
    # either before each or all, before a test. In the 'open the front page'
    # block above, the URL is visited once for each test. 
    # 
    # In many ways it is similar to before_action or before_filter in a 
    # controller.
    #
    # /let/, however, is called once and cached.
    # 
    # Build (used above) does not persist in memory, but create does. It also
    # seems to call on Authlogic methods, such that the attributes needed for a
    # user session aren't created.
    #
    # Authlogic uses the user's ID to generate a session. I need to build a
    # phantom user who has an ID attribute set.
    #
    # Ways I have to create a user:
    #
    # 1. Create adds a user to the database.
    FactoryGirl.create(:user)
    #
    # 2. Build creates a user only in memory.
    # FactoryGirl.build(:user)
    #
    # 3. Call the model directly User.create(...).
    # spawn_test_user

    # Authlogic silently fails to create a session, upon login, unless the
    # user is created with the create_user call. A user created by
    # 
    #   FactoryGirl.create(:user)
    #   FactoryGirl.build(:user)
    #
    # Why is this so, and how can I avoid it in future? My understanding is that
    # a major chokepoint of tests are areas of contact with the filesystem, and
    # the database in particular. A goal of FactoryGirl is to avoid this 
    # contact with pastiche, kinda-sorta-good enough objects.
    #
    # Update 7/12/2015: AuthLogic requires the user to exist in the database. It
    # appears that the session credentials are derived from the database ID of
    # the user. So the session will fail and your test fails.
  end
  
  it 'test user should exist' do
    expect(test_user).not_to be_falsey
  end

  it 'page should contain the timeline' do
    visit root_url

    within '#login' do
      fill_in 'Username or email', with: test_user.email
      fill_in 'Password', with: test_user.password
      click_button 'Log in'
    end

    # expect(page).to have_css '#tweets'
    expect(page).to have_content 'Nttrs'
  end
end
