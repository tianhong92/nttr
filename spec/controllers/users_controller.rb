require 'spec_helper'
require 'rails_helper'

describe UsersController, type: :controller do

  describe 'GET #show' do
    context 'when user is logged in it should' do
      setup :activate_authlogic 

      let(:test_user) do
        # As before: build doesn't persist; create does.
        # If I want to examine a user's show page, then I *must* pull a record
        # from the database to which the controller may route. The difference
        # can be reduced thus:
        #
        # FactoryGirl.build(:whatever) does not call the save method.
        FactoryGirl.create(:user)
      end

      let(:session) do
        # let! and let declare variables which are available at the scope of:
        #
        #   let
        #   before
        #   it
        #   describe (nested)
        #
        # So inside each of these, the variables become available.
        # login test_user
      end

      before do
        get :show, id: test_user.id
      end

      it 'render :show for that ID' do
        expect(response).to render_template(:show)
      end

      it 'have a valid session' do
        expect(session).to be_truthy
      end
    end
  end
end
