require 'rails_helper'

RSpec.describe ResourceCategoriesController, type: :controller do

  let(:admin) { create(:user, role: :admin) }
  let(:non_admin) { create(:user) }

  let!(:category) { create(:resource_category, name: "test category") }

  describe "GET index" do
    it "redirects to sign in when logged out" do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end

    it "blocks non-admin" do
      sign_in non_admin
      get :index
      expect(response).to redirect_to(dashboard_path)
    end

    it "renders for the admin" do
      sign_in admin
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET show" do
    it "renders for admin" do
      sign_in admin
      get :show, params: { id: category.id }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET new" do
    it "renders for admin" do
      sign_in admin
      get :new
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET edit" do
    it "renders for admin" do
      sign_in admin
      get :edit, params: { id: category.id }
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST create" do
    before {sign_in admin}

    context "with valid params" do
      it "creates and redirects" do
        expect {
          post :create, params: { resource_category: { name: "New Category" } }
        }.to change(ResourceCategory, :count).by(1)

        expect(response).to redirect_to(resource_categories_path)
      end
    end

    context "with invalid params" do
      it "does not create and renders new" do
        expect {
          post :create, params: { resource_category: { name: "" } }
        }.not_to change(ResourceCategory, :count)

        expect(response).not_to be_redirect
      end
    end
  end

  context "as non-admin" do
    it "redirects non-admin users" do
      sign_in non_admin
      patch :update, params: {
        id: category.id,
        resource_category: { name: "New Name" }
      }

      expect(response).to redirect_to(dashboard_path)
    end
  end

  context "when logged out" do
    it "redirects to sign in" do
      patch :update, params: {
        id: category.id,
        resource_category: { name: "New Name" }
      }

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "POST activate" do
    before { sign_in admin }

    it "activates and redirects with notice" do
      allow_any_instance_of(ResourceCategory).to receive(:activate).and_return(true)

      post :activate, params: { id: category.id }

      expect(response).to redirect_to(category)
    end

    it "redirects with alert if activation fails" do
      allow_any_instance_of(ResourceCategory).to receive(:activate).and_return(false)

      post :activate, params: { id: category.id }

      expect(response).to redirect_to(category)
    end
  end

  describe "POST deactivate" do
    before { sign_in admin }

    it "deactivates and redirects with notice" do
      allow_any_instance_of(ResourceCategory).to receive(:deactivate).and_return(true)

      post :deactivate, params: { id: category.id }

      expect(response).to redirect_to(category)
    end

    it "redirects with alert if deactivation fails" do
      allow_any_instance_of(ResourceCategory).to receive(:deactivate).and_return(false)

      post :deactivate, params: { id: category.id }

      expect(response).to redirect_to(category)
    end
  end

  describe "PATCH update" do
  context "as admin" do
    before { sign_in admin }

    it "updates the category and redirects on success" do
      patch :update, params: {
        id: category.id,
        resource_category: { name: "Updated Name" }
      }

      category.reload
      expect(category.name).to eq("Updated Name")
      expect(response).to redirect_to(category)
      expect(flash[:notice]).to eq("Category successfully updated.")
    end

    it "renders edit when update fails" do
      allow_any_instance_of(ResourceCategory)
        .to receive(:update)
        .and_return(false)

      patch :update, params: {
        id: category.id,
        resource_category: { name: "" }
      }

      expect(response).to have_http_status(:ok)
      expect(response).not_to be_redirect
    end
  end

  context "as non-admin" do
    it "redirects non-admin users" do
      sign_in non_admin
      patch :update, params: {
        id: category.id,
        resource_category: { name: "New Name" }
      }

      expect(response).to redirect_to(dashboard_path)
    end
  end

  context "when logged out" do
    it "redirects to sign in" do
      patch :update, params: {
        id: category.id,
        resource_category: { name: "New Name" }
      }

      expect(response).to redirect_to(new_user_session_path)
    end
  end
end


  describe "DELETE destroy" do
    before { sign_in admin }

    it "calls service and redirects" do
      service = instance_double(DeleteResourceCategoryService, run!: true)
      allow(DeleteResourceCategoryService).to receive(:new).with(instance_of(ResourceCategory)).and_return(service)

      delete :destroy, params: { id: category.id }

      expect(service).to have_received(:run!)
      expect(response).to redirect_to(resource_categories_path)
    end
  end
end
