require 'rails_helper'

RSpec.describe 'Approving an organization', type: :feature do
  scenario 'Admin approves an organization application' do
    admin = create_admin_user
    org = create_submitted_organization(name: 'Test Org', email: 'test-org@example.com')

    sign_in_as(admin)
    visit "/organizations/#{org.id}"

    click_link 'Approve'

    expect(page).to have_content('Organization Test Org has been approved.')
    expect(org.reload).to be_approved
  end
end