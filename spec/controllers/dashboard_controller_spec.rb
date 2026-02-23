require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  let(:admin) { create(:user, role: :admin) }
  let(:non_admin) { create(:user) }

  describe "#after_sign_in_path_for" do
    it "returns the dashboard path" do
      path = subject.after_sign_in_path_for(admin)
      expect(path).to eq(dashboard_path)
    end
  end

  describe "authenticate_admin (via controller action)" do
    controller do
      before_action :authenticate_admin

      def index
        render plain: "OK"
      end
    end

    context "when admin" do
      before { sign_in admin }

      it "allows access" do
        get :index
        expect(response).to have_http_status(:ok)
      end
    end

    context "when non-admin" do
      before { sign_in non_admin }

      it "redirects to dashboard with alert" do
        get :index
        expect(response).to redirect_to(dashboard_path)
      end
    end

    context "when logged out" do
      it "redirects to sign in" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end