require 'rails_helper'

RSpec.describe 'Deleting a Resource Category', type: :feature do
  scenario 'Admin deletes an existing resource category' do
    admin = create_admin_user
    category = ResourceCategory.create!(name: 'Food')
    region = Region.create!(name: 'Central')

    ticket = Ticket.create!(
      name: 'Need groceries',
      description: 'Family needs food support',
      phone: '+15414541232',
      region: region,
      resource_category: category
    )

    sign_in_as(admin)
    visit "/resource_categories/#{category.id}"

    page.driver.submit :delete, "/resource_categories/#{category.id}", {}

    expect(page).to have_content('Category Food was deleted')
    expect(ResourceCategory.where(id: category.id)).to be_empty
    expect(ticket.reload.resource_category).to eq(ResourceCategory.unspecified)
  end
end