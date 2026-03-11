require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  let(:admin) { create(:user, role: :admin) }
  let(:non_admin) { create(:user) }

  let(:approved_org) { create(:organization, status: :approved) }
  let(:unapproved_org) { create(:organization) }

  let(:approved_user) { create(:user, organization: approved_org) }
  let(:unapproved_user) { create(:user) }

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
  
  describe "Dashboard" do
    it "exists" do
      expect(Dashboard).to be_a(Module)
    end
  end

  describe "GET index" do
    before do
      allow(controller).to receive(:pagy).and_return([double("pagy"), Ticket.none])
    end

    context "when admin" do
      before { sign_in admin }

      it "returns ok" do
        get :index

        expect(response).to have_http_status(:ok)
      end
    end

    context "when approved organization user" do
      before { sign_in approved_user }

      it "returns ok" do
        get :index

        expect(response).to have_http_status(:ok)
      end
    end

    context "when regular user" do
      before { sign_in unapproved_user }

      it "returns ok" do
        get :index

        expect(response).to have_http_status(:ok)
      end
    end

    context "when status is Open" do
      before { sign_in admin }

      it "loads open tickets" do
        expect(Ticket).to receive(:open).and_return(Ticket.none)
        get :index, params: { status: 'Open' }
      end
    end

    context "when status is Closed" do
      before { sign_in admin }

      it "loads closed tickets" do
        expect(Ticket).to receive(:closed).and_return(Ticket.none)
        get :index, params: { status: 'Closed' }
      end
    end

    context "when status is Captured" do
      before { sign_in admin }

      it "loads captured tickets" do
        expect(Ticket).to receive(:all_organization).and_return(Ticket.none)
        get :index, params: { status: 'Captured' }
      end
    end

    context "when status is My Captured" do
      before { sign_in approved_user }

      it "loads organization tickets" do
        expect(Ticket).to receive(:organization).with(approved_user.organization.id).and_return(Ticket.none)
        get :index, params: { status: 'My Captured' }
      end
    end

    context "when status is My Closed" do
      before { sign_in approved_user }

      it "loads closed organization tickets" do
        expect(Ticket).to receive(:closed_organization).with(approved_user.organization.id).and_return(Ticket.none)
        get :index, params: { status: 'My Closed' }
      end
    end

    context "when filtering and sorting" do
      let(:relation) { double("ticket_relation") }

      before { sign_in admin }

      it "applies region, resource category, and reverse order" do
        allow(Ticket).to receive(:all).and_return(relation)
        allow(controller).to receive(:pagy).with(relation, items: 10).and_return([double("pagy"), relation])
        allow(relation).to receive(:region).with("1").and_return(relation)
        allow(relation).to receive(:resource_category).with("2").and_return(relation)
        allow(relation).to receive(:reverse).and_return(relation)

        get :index, params: {
          region_id: "1",
          resource_category_id: "2",
          sort_order: "Newest First"
        }

        expect(response).to have_http_status(:ok)
      end
    end
  end
end