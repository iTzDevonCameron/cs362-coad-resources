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
end
