require 'rails_helper'

RSpec.describe 'Creating a Ticket', type: :feature do
  scenario 'User creates a ticket' do
    region = Region.create!(name: 'North')
    category = ResourceCategory.create!(name: 'Food')

    visit '/tickets/new'

    fill_in 'Full Name', with: 'Need Food'
    fill_in 'Description', with: 'Family needs groceries'
    fill_in 'Phone Number', with: '5413821234'
    select 'North', from: 'Region'
    select 'Food', from: 'Resource Category'

    click_button 'Send this help request'

    expect(page).to have_content('Ticket Submitted')
    expect(Ticket.last.name).to eq('Need Food')
    expect(Ticket.last.region).to eq(region)
    expect(Ticket.last.resource_category).to eq(category)
  end
end