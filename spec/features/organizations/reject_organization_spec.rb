require 'rails_helper'

RSpec.describe 'Rejecting an organization', type: :feature do
  scenario 'Admin rejects an organization application' do
    admin = create_admin_user
    org = create_submitted_organization(name: 'Reject Org', email: 'reject-org@example.com')

    sign_in_as(admin)
    visit "/organizations/#{org.id}"

    fill_in 'Rejection Reason', with: 'Missing information'
    click_button 'Reject'

    expect(page).to have_content('Organization Reject Org has been rejected.')
    expect(org.reload).to be_rejected
    expect(org.rejection_reason).to eq('Missing information')
  end
end