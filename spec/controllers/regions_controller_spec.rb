# spec/controllers/regions_controller_spec.rb
require "rails_helper"

RSpec.describe RegionsController, type: :controller do
  describe "as a logged-out user" do
    it "redirects to sign in" do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "as a logged-in user (non-admin)" do
    let(:user) { create(:user) }

    before { sign_in user }

    it "redirects to dashboard" do
      get :index
      expect(response).to redirect_to(dashboard_path)
    end
  end

  describe "as an admin" do
    let(:admin) { create(:user, :admin) }

    before { sign_in admin }

    describe "GET #index" do
      it "is successful" do
        get :index
        expect(response).to be_successful
      end
    end

    describe "GET #show" do
      let(:region) { create(:region) }

      it "is successful" do
        get :show, params: { id: region.id }
        expect(response).to be_successful
      end
    end

    describe "GET #new" do
      it "is successful" do
        get :new
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a region and redirects" do
          expect {
            post :create, params: { region: { name: "North" } }
          }.to change(Region, :count).by(1)

          expect(response).to redirect_to(regions_path)
          expect(flash[:notice]).to eq("Region successfully created.")
        end
      end

      context "with invalid params" do
        it "does not create and returns a non-redirect response" do
          expect {
            post :create, params: { region: { name: "" } }
          }.not_to change(Region, :count)

          expect(response).not_to be_redirect
          expect(response).to have_http_status(:unprocessable_entity).or have_http_status(:ok)
        end
      end
    end

    describe "GET #edit" do
      let(:region) { create(:region) }

      it "is successful" do
        get :edit, params: { id: region.id }
        expect(response).to be_successful
      end
    end

    describe "PATCH #update" do
      let(:region) { create(:region, name: "Old") }

      context "with valid params" do
        it "updates and redirects" do
          patch :update, params: { id: region.id, region: { name: "New" } }

          expect(response).to redirect_to(region_path(region))
          expect(flash[:notice]).to eq("Region successfully updated.")
          expect(region.reload.name).to eq("New")
        end
      end

      context "with invalid params" do
        it "does not update and re-renders :edit" do
          patch :update, params: { id: region.id, region: { name: "" } }

          expect(response).to have_http_status(:unprocessable_entity).or have_http_status(:ok)
          expect(region.reload.name).to eq("Old")
        end
      end
    end

    describe "DELETE #destroy" do
      let(:region) { create(:region, name: "DeleteMe") }

      it "calls DeleteRegionService and redirects" do
        service = instance_double(DeleteRegionService, run!: true)
        allow(DeleteRegionService).to receive(:new).with(instance_of(Region)).and_return(service)

        delete :destroy, params: { id: region.id }

        expect(service).to have_received(:run!)
        expect(response).to redirect_to(regions_path)
        expect(flash[:notice]).to include("Region #{region.name} was deleted")
      end
    end
  end
end
