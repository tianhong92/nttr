require 'spec_helper'
require 'rails_helper'

describe UsersController, type: :routing do
  setup :activate_authlogic

  let!(:test_user) do
    FactoryGirl.create(:user)
  end

  before do
    login test_user
  end

  it 'routes to index' do
    expect(get: 'users').to route_to(
      controller: 'users',
      action: :index
    )
  end
end
