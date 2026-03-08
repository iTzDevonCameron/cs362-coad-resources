require 'rails_helper'

RSpec.describe 'Creating a Region', type: :feature do
  scenario 'admin creates a region' do
    admin = create_admin_user

    sign_in_as(admin)
    visit '/regions'

    click_link 'Add Region'
    fill_in 'Name', with: 'Northwest'
    click_button 'Add Region'

    expect(page).to have_content('Region successfully created.')
    expect(page).to have_content('Northwest')
  end
end