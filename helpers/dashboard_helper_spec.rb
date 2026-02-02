require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the DashboardHelper. For example:
#
# describe DashboardHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe DashboardHelper, type: :helper do
  describe "dashboard tests" do
    let (:helper) { Object.new.extend(DashboardHelper) }
    let (:test_user_admin) { User.new(
      role: "admin"
    ) }
    let (:organization_approved) { Organization.new(status: "approved") }
    let (:organization_submitted) { Organization.new(status: "submitted") }
    let (:test_user_organization_submitted) { User.new(
      role: "organization",
      organization: organization_submitted
    ) }
    let (:test_user_organization_approved) { User.new(
      role: "organization",
      organization: organization_approved
    ) }
    let (:test_user_undefined) { User.new }
    it "Admin user returns 'admin_dashboard'" do
      response = helper.dashboard_for(test_user_admin)
      expect(response).to eq "admin_dashboard"
    end
    it "Admin user returns 'organization_submitted_dashboard'" do
      response = helper.dashboard_for(test_user_organization_submitted)
      expect(response).to eq "organization_submitted_dashboard"
    end
    it "Organization user returns 'organization_approved_dashboard'" do
      response = helper.dashboard_for(test_user_organization_approved)
      expect(response).to eq "organization_approved_dashboard"
    end
    it "Not defined user returns 'create_application_dashboard'" do
      response = helper.dashboard_for(test_user_undefined)
      expect(response).to eq "create_application_dashboard"
    end
  end
end
