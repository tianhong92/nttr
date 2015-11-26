require 'spec_helper'
require 'rails_helper'

def create_user(name = 'birdmen')
  password = "ilove#{name.delete(' ').split(//).shuffle!.join}"

  # SKRAW-W-W-W-W!
  @user = User.create(
    login: name,
    email: "angry.#{name}@bhalash.com",
    nicename: "Angry #{name.capitalize}",
    password: password,
    password_confirmation: password 
  )
end

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
  # difference between the two methods. Think of it in terms of plain 
  # language: You /describe/ a set of tests, you /give context/ for a set of
  # tests.
  
  # Setup can only be called from the top of a context or describe block.
  # See: spec/rails_helper.rb for how AuthLogic was initialized.
  setup :activate_authlogic 

  let(:test_user) do
    # Link: https://goo.gl/9UzXG6
    #
    # The difference between before and let is that before is called once, 
    # each time, before a test. In the 'open the front page' block above, 
    # the URL is visited once for each test. 
    # 
    # In many ways it is similar to before_action or before_filter in a 
    # controller.
    #
    # /let/, however, is called once and cached.
    #
    # create_user('squid')

    # Build (used above) does not persist in memory,
    # Create does. It also seems to call on Authlogic methods, such that the 
    # attributes needed for a user session aren't created.
    #
    # TODO: Figure out why.
    # Authlogic uses the user's ID to generate a session. I need to build a
    # phantom user who has an ID attribute set.
    
    # Create adds a user to the database.
    # FactoryGirl.create(:user)
    # Build creates a user only in memory.
    FactoryGirl.create(:user)

    # TODO: Authlogic silently fails to create a session, upon login, unless the
    # user is created with the create_user call. A user-in-memory created by
    # 
    # FactoryGirl.create(:user) or FactoryGirl.build(:user)
    #
    # does not work, nor does a manual call to 
    #
    # UserSession.create(:test_user)
    #
    # Why is this so, and how can I avoid it in future? My understanding is that
    # a major chokepoint of tests are areas of contact with the filesystem, and
    # the database in particular. A goal of FactoryGirl is to avoid this 
    # contact with pastiche, kinda-sorta-good enough objects.
  end

  # let!(:existing_user) do
  #   # Fetch existing user. Not used because it duplicates the above.
  #   @user = User.find_by_email('pony.lover@sonru.com')
  #   UserSession.create(@user)
  # end
  
  # The test user (as an object) is only available within the scope of the spec
  # tests. This line will throw an error.
  # p test_user
  
  before(:each) do
    UserSession.create(test_user)
  end

  it 'user should exist' do
    p test_user
    expect(test_user).not_to be_falsey
  end

  it 'the login form should work' do
    visit root_url

    # within '#login' do
    #   fill_in 'Username or email', with: test_user.email
    #   fill_in 'Password', with: test_user.password
    #   click_button 'Log in'
    # end

    within '#tweets' do
      expect(page).to have_content 'Nttrs'
    end
  end
end
