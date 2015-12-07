require 'spec_helper'
require 'rails_helper'

describe 'When viewing Nttr the page' do
  # RSpec has test syntax. Capybara only extends this to web page features.
  # Cheat sheet for Capybara expect and general syntax: 
  # Link: https://gist.github.com/zhengjia/428105
  
  # General RSpec expect:
  # Link: https://github.com/rspec/rspec-expectations

  before(:each) do
    visit root_url
  end
      
  it 'should display the title' do
    # within '#welcome' do
    within 'div[id^=welcome]:not(:nth-child(3))' do
      # 'within' accepts any valid CSS3 selector, so crazy selectors like the
      # above will work grand (but don't worry about anything but general class
      # or ID selectors unless you're a crazy-eyed CSS guru like me).
      #
      # See: http://www.w3schools.com/cssref/css_selectors.asp
      expect(page).to have_content 'Welcome to nttr.'
    end
  end

  it do 
    # If the label is blank, one is generated. This outputs:
    #
    #   should have css ".container"
    #
    expect(page).to have_css('.container', 'margin-right: auto')
  end

  # Will be flagged as PENDING: Not yet implemented
  it 'and find the registration form'

  it 'should display magical ponies' do
    within('#register') do
      # Deliberate failing test.
      expect(page).to have_content 'LITERALLY MAGIC PONIES'
    end
  end
end

context 'While logged in' do
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
    # Ways to to create a user (with FactoryGirl):
    #
    # 1. Create adds a user to the database.
    FactoryGirl.create(:user)
    #
    # 2. Build creates a user only in memory.
    # FactoryGirl.build(:user)
    #
    # 3. Call the model directly User.create(...).
    # spawn_test_user
    #
    # AuthLogic is picky. In order to create a session, there must exist:
    #
    # 1. A user in the database. NOT in memory. FactoryGirl.create or 
    #    User.create must be called.
    # 2. A session created using the login form (more below).
    #
    # On AuthLogic feature test sessions:
    # UserSession.create(test_user) does nothing at all during a feature test. 
    # AuthLogic requires a cookie to be present in the browser. So, say you 
    # create a user session with UserSession.create(test_user). This happens:
    #
    # 1. A user session is created on the server.
    # 2. The client visitor (Capybara, in this case) wants to view authenticated
    #    areas of the website. 
    # 3. AuthLogic looks for a cookie named (_Authy_session) with the relevant
    #    session token. 
    # 4. This cookie does not exist, so AuthLogic performs whatever action you
    #    have set up to occur when someone tries to access the authenticated
    #    area (in my case it is a silent redirect to the root page).
    #
    # You can work around this, although it goes against the spirit of a
    # complete feature test, if you set a cookie after you create the session:
    #
    #   UserSession.create(test_user)
    #   Capybara.current_session.driver.browser.set_cookie = "#{@user.persistence_token}::#{@user.send(@user.class.primary_key)}"
    #
    # See: http://www.spacevatican.org/2011/12/5/request-specs-and-authlogic/
  end

  it 'test user should exist' do
    expect(User.where(login: test_user.login)).to exist
  end

  context 'Test user should' do
    let!(:session) do
        # You could create a session and cookie here if you so wished.
        log_in_as test_user
    end

    it 'see the timeline' do
      expect(page).to have_content 'Nttrs'
    end

    it 'see the broadcast form' do
      expect(page).to have_css '#broadcast'
    end
  end
end

context 'While on the home page as a user' do
  setup :activate_authlogic 

  let(:test_user) do
    FactoryGirl.create(:user)
  end
  
  it 'should be able to broadcast a nttr' do
    as_user test_user do
      # Example of yielded block. as_user:
      #   
      # 1. Visits the login page.
      # 2. Completes the form with the test user's login and password.
      # 3. Submits the login form.
      # 4. Yields to the passed block.
      within '#broadcast' do
        fill_in 'tweet_content', with: 'Lorem ipsum doo doo doo poo poo.'
        click_button 'tweet_submit'
      end
      
      expect(page.status_code).to be(200)
    end
  end
end
