require 'rails_helper'

RSpec.describe OrganizationsController, type: :controller do

    let(:admin) { create(:user, role: :admin) }
    let(:non_admin) { create(:user) }

    let(:approved_org) { create(:organization, status: :approved) }
    let(:submitted_org) { create(:organization, status: :submitted) }


    describe "GET index" do
        it "redirects to sign in when not logged in" do
            get :index
            expect(response).to redirect_to(new_user_session_path)
        end

        it "renders the page when non-admin logs in" do
            sign_in non_admin
            get :index
            expect(response).to have_http_status(:ok)
        end
    end


    describe "GET show" do
      it "allows admin to see the organization" do
        sign_in admin
        get :show, params: { id: submitted_org.id }
        expect(response).to have_http_status(:ok)
      end
    end

end
