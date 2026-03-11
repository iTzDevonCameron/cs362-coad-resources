require "rails_helper"

RSpec.describe Users::RegistrationsController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    allow(controller).to receive(:verify_recaptcha).and_return(false)
  end

  describe "POST #create" do
    it "returns ok when recaptcha fails" do
      post :create, params: {
        user: {
          email: "test@example.com",
          password: "Password123!",
          password_confirmation: "Password123!"
        }
      }

      expect(response).to have_http_status(:ok)
    end
  end
end