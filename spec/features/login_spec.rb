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
      #   after_([:each, :all, :suite])  
      #   before_([:each, :all, :suite])
      visit root_url
    end

    describe 'examine content' do
      # Nested tests.
      
      it 'and find the welcome title' do
        expect(page).to have_content 'Welcome to nttr.'
      end

      it 'and find the login form' do
        expect(page).to have_content 'Remember me'
      end

      # Will be flagged as PENDING: Not yet implemented
      it 'and find the registration form'
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

context 'When logged into Nttr' do
  # 'context' and 'describe' are synonymous: There is no programmatic
  # difference between the two methods. Think of it in terms of plain 
  # language: You /describe/ a set of tests, you /give context/ for a set of
  # tests.
  let!(:standard_user) do
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
    @user = User.create(
      # I use slightly different fields from my user than in the email.
      login: 'pony',
      email: 'pony.lover@sonru.com',
      nicename: 'Pony Lover',
      password: 'iloveponies',
      password_confirmation: 'iloveponies'
    )
  end

  # let!(:existing_user) do
  #   # Fetch existing user. Not used because it duplicates the above.
  #   @user = User.find_by_email('pony.lover@sonru.com')
  # end

  before(:all) do
    UserSession.create(@user)
  end

  it 'test user should exist' do
    # This is tautological..circular: If the user exists, I check if the user
    # exists. It's still a nice example of context. Moving /on/
    expect(User.where(email: 'pony.lover@sonru.com')).to exist
  end

  it 'existing user name should exist' do
    # Another tautological test. I declare the @user variable, and test the 
    # user's ID here.
    expect(@user.nicename).to eq('Pony Lover')
  end

  it 'persistence token should exist' do
    expect(@user.persistence_token).to_not be_nil
  end
end
