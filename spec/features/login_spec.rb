require 'spec_helper'
require 'rails_helper'

describe 'Nttr' do
  it 'loads up' do
    visit '/'
    expect(page).to have_content 'Welcome to nttr.'
  end
end
