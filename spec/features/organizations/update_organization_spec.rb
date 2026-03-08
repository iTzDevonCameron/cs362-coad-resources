require 'rails_helper'

RSpec.describe 'Updating an Organization', type: :feature do
  scenario 'Approved organization user updates an organization' do
    org = create_approved_organization(name: 'Old Name', email: 'old-name@example.com')
    user = create_confirmed_user(email: 'org-user@example.com', organization: org)

    sign_in_as(user)
    visit "/organizations/#{org.id}/edit"

    fill_in 'Name', with: 'New Name'
    fill_in 'Phone', with: '5416171234'
    fill_in 'Description', with: 'Updated organization description'

    click_button 'Update Resource'

    expect(page).to have_content('New Name')
    expect(org.reload.name).to eq('New Name')
  end
end