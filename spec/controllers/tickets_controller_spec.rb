require 'rails_helper'

RSpec.describe TicketsController, type: :controller do
  
  let(:region) { create(:region) }
  let(:resource_category) { create(:resource_category) }


  
  let(:approved_org) { create(:organization, status: :approved) }
  let(:unapproved_org) { create(:organization) }

  let(:approved_user) { create(:user, organization: approved_org) }
  let(:unapproved_user) { create(:user) }

  let(:admin) { create(:user, role: :admin, organization: approved_org) }
  let(:non_admin) { create(:user) }

  describe "Get #new" do
    it "renders the new page" do
      get :new
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST #create" do
    let(:params) do
      {
        ticket: {
          name: "test user",
          phone: "555-555-5555",
          description: "test description",
          region_id: region.id,
          resource_category_id: resource_category.id
        }  
      }
    end

    it "creates a ticket and redirects on success" do
      post :create , params: params
      expect(response).to redirect_to(ticket_submitted_path)
    end

    it "fails to create ticket, " do
      # Force save failure without depending on validations
      allow_any_instance_of(Ticket).to receive(:save).and_return(false)

      post :create, params: params
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #show" do
    let(:ticket) { create(:ticket, region: region, resource_category: resource_category) }
    
    
    
    it "redirects to dashboard if not signed in" do
      sign_in non_admin
      get :show, params: { id: ticket.id }
      expect(response).to redirect_to(dashboard_path)
    end

    
    
    it "finds ticket if signed in as approved" do
      sign_in approved_user
      get :show, params: { id: ticket.id }
      expect(response).to have_http_status(:ok)
    end

    it "finds ticket if signed in as admin" do
      sign_in admin
      get :show, params: { id: ticket.id }
      expect(response).to have_http_status(:ok)
    end
  end


  describe "POST #capture" do
    let(:ticket) { create(:ticket, region: region, resource_category: resource_category) }

    it "redirects to dashboard if unapproved" do
      sign_in unapproved_user

      post :capture, params: {id: ticket.id}
      expect(response).to redirect_to(dashboard_path)
    end

    it "redirects to dashboard" do
      sign_in approved_user
      allow(TicketService).to receive(:capture_ticket).with(ticket.id.to_s, approved_user).and_return(:ok)

      post :capture, params: { id: ticket.id }
      expect(response).to redirect_to(dashboard_path + "#tickets:open")
    end

    it "renders :show when service returns failure" do
      sign_in approved_user
      allow(TicketService).to receive(:capture_ticket).and_return(false)

      post :capture, params: { id: ticket.id }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST #release" do
    let(:ticket) { create(:ticket, region: region, resource_category: resource_category) }

    it "redirects to dashboard if org not approved" do
      sign_in unapproved_user

      post :release, params: { id: ticket.id }
      expect(response).to redirect_to(dashboard_path)
    end

    it "redirects to dashboard for admin" do
      sign_in admin
      allow(TicketService).to receive(:release_ticket).with(ticket.id.to_s, admin).and_return(:ok)

      post :release, params: { id: ticket.id }
      expect(response).to redirect_to(dashboard_path + "#tickets:captured")
    end

    it "redirects to dashboard for admin" do
      sign_in approved_user
      allow(TicketService).to receive(:release_ticket).with(ticket.id.to_s, approved_user).and_return(:ok)

      post :release, params: { id: ticket.id }
      expect(response).to redirect_to(dashboard_path + "#tickets:organization")
    end

    it "renders :show when service returns failure" do
      sign_in approved_user
      allow(TicketService).to receive(:capture_ticket).and_return(false)

      post :release, params: { id: ticket.id }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST #close" do
    let(:ticket) { create(:ticket, region: region, resource_category: resource_category) }

    it "redirects to dashboard if org not approved and not admin" do
      sign_in unapproved_user

      post :close, params: { id: ticket.id }
      expect(response).to redirect_to(dashboard_path)
    end

    it "redirects to #tickets:open for admin on :ok" do
      sign_in admin
      allow(TicketService).to receive(:close_ticket).with(ticket.id.to_s, admin).and_return(:ok)

      post :close, params: { id: ticket.id }
      expect(response).to redirect_to(dashboard_path + "#tickets:open")
    end

    it "redirects to #tickets:organization for non-admin on :ok" do
      sign_in approved_user
      allow(TicketService).to receive(:close_ticket).with(ticket.id.to_s, approved_user).and_return(:ok)

      post :close, params: { id: ticket.id }
      expect(response).to redirect_to(dashboard_path + "#tickets:organization")
    end

    it "renders :show when service returns non-ok" do
      sign_in approved_user
      allow(TicketService).to receive(:close_ticket).and_return(:nope)

      post :close, params: { id: ticket.id }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE #destroy" do
    let!(:ticket) { create(:ticket, region: region, resource_category: resource_category) }

    it "redirects (denies) if not admin (before_action authenticate_admin)" do
      sign_in approved_user

      delete :destroy, params: { id: ticket.id }
      expect(response).to redirect_to(dashboard_path)
      expect(Ticket.exists?(ticket.id)).to eq(true)
    end

    it "destroys and redirects to dashboard#tickets with notice if admin" do
      sign_in admin

      delete :destroy, params: { id: ticket.id }

      expect(response).to redirect_to(dashboard_path + "#tickets")
      expect(flash[:notice]).to eq("Ticket #{ticket.id} was deleted.")
      expect(Ticket.exists?(ticket.id)).to eq(false)
    end
  end
end
