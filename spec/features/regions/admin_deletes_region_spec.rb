require 'rails_helper'

RSpec.describe 'Deleting a Region', type: :feature do
  scenario 'Admin deletes an existing region' do
    admin = create_admin_user
    region = Region.create!(name: 'Delete Me')
    category = ResourceCategory.create!(name: 'Test Category')

    ticket = Ticket.create!(
      name: 'Test Ticket',
      description: 'Test description',
      phone: '+15414541232',
      region: region,
      resource_category: category
    )

    sign_in_as(admin)
    visit "/regions/#{region.id}"

    page.driver.submit :delete, "/regions/#{region.id}", {}

    expect(page).to have_content('Region Delete Me was deleted')
    expect(Region.where(id: region.id)).to be_empty
    expect(ticket.reload.region).to eq(Region.unspecified)
  end
end