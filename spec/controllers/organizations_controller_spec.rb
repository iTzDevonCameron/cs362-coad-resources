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

    describe "POST create" do
  let(:user) { create(:user) }
  let!(:category) { create(:resource_category) }
  let!(:admin_user) { create(:user, role: :admin) }

  before { sign_in user }

  context "when valid" do
    it "creates submitted organization and redirects" do
      allow(controller).to receive(:verify_unapproved).and_return(true)

      expect {
        post :create, params: {
          organization: {
            name: "New Org",
            phone: "123",
            email: "test@test.com",
            description: "Desc",
            liability_insurance: "None",
            primary_name: "Joey",
            secondary_name: "Tribianni",
            secondary_phone: "456",
            title: "Cool Guys",
            transportation: "yes",
            resource_category_ids: [category.id]
          }
        }
      }.to change(Organization, :count).by(1)

      expect(response).to redirect_to(organization_application_submitted_path)
    end
  end

  context "when invalid" do
    it "renders new" do
      post :create, params: { organization: { name: "" } }

      expect(response).not_to be_redirect
      expect(response).to have_http_status(:ok)
    end
  end
end

describe "PATCH update" do
  let(:approved_org) { create(:organization, status: :approved) }
  let(:user) { create(:user, organization: approved_org) }

  before { sign_in user }

  context "with valid params" do
    it "updates and redirects" do
      patch :update, params: {
        id: approved_org.id,
        organization: { name: "Updated" }
      }

      expect(response).to redirect_to(organization_path(id: approved_org.id))
      expect(approved_org.reload.name).to eq("Updated")
    end
  end

  context "with invalid params" do
    it "renders edit" do
      allow_any_instance_of(Organization)
        .to receive(:update)
        .and_return(false)

      patch :update, params: {
        id: approved_org.id,
        organization: { name: "" }
      }

      expect(response).not_to be_redirect
    end
  end
end

describe "POST approve" do
  let(:org) { create(:organization, status: :submitted) }

  before { sign_in admin }

  it "approves and redirects" do
    allow_any_instance_of(Organization).to receive(:approve)

    post :approve, params: { id: org.id }

    expect(response).to redirect_to(organizations_path)
  end
end

describe "POST reject" do
  let(:org) { create(:organization, status: :submitted) }

  before { sign_in admin }

  it "rejects and redirects" do
    allow_any_instance_of(Organization).to receive(:reject)

    post :reject, params: {
      id: org.id,
      organization: { rejection_reason: "Incomplete" }
    }

    expect(response).to redirect_to(organizations_path)
  end
end

describe "verify_unapproved filter" do
  let(:org) { create(:organization) }
  let(:user_with_org) { create(:user, organization: org) }

  before { sign_in user_with_org }

  it "redirects to dashboard" do
    get :new
    expect(response).to redirect_to(dashboard_path)
  end
end

describe "verify_approved filter" do
  let(:submitted_org) { create(:organization, status: :submitted) }
  let(:user) { create(:user, organization: submitted_org) }

  before { sign_in user }

  it "redirects to dashboard" do
    get :edit, params: { id: submitted_org.id }
    expect(response).to redirect_to(dashboard_path)
  end
end

describe "verify_user filter" do
  let(:submitted_org) { create(:organization, status: :submitted) }
  let(:user) { create(:user, organization: submitted_org) }

  before { sign_in user }

  it "redirects non-approved user from show" do
    get :show, params: { id: submitted_org.id }
    expect(response).to redirect_to(dashboard_path)
  end
end

end