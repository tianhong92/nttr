require 'spec_helper'
require 'rails_helper'

describe UsersController, type: :routing do
  # TODO: Question: Is detailing routes in this manner tautological?
  setup :activate_authlogic

  it 'routes get users' do
    # Users index.
    expect(get: users_path).to route_to(
      controller: 'users',
      action: 'index'
    )
  end

  it 'routes get new user' do
    # New user form.
    expect(get: new_user_path).to route_to(
      controller: 'users',
      action: 'new'
    )
  end

  it 'routes post create user' do
    # Create user action.
    expect(post: users_path).to route_to(
      controller: 'users',
      action: 'create'
    )
  end

  it 'routes get show user' do
    # Show single user.
    expect(get: user_path(1)).to route_to(
      controller: 'users',
      action: 'show',
      # String, not number.
      id: '1'
    )
  end

  it 'routes get edit' do
    # Get edit user form.
    expect(get: edit_user_path(1)).to route_to(
      controller: 'users',
      action: 'edit',
      id: '1'
    )
  end

  it 'routes post update' do
    expect(put: user_path(1)).to route_to(
      controller: 'users',
      action: 'update',
      id: '1'
    )
  end

  it 'routes post delete' do
    expect(delete: user_path(1)).to route_to(
      controller: 'users',
      action: 'destroy',
      id: '1'
    )
  end
end
