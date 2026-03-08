require 'rails_helper'

RSpec.describe 'Capturing a ticket', type: :feature do
  scenario 'Approved organization user captures a ticket' do
    org = create_approved_organization
    user = create_confirmed_user(email: 'capturer@example.com', organization: org)
    ticket = create_ticket_record(name: 'Capture Test')

    sign_in_as(user)
    visit "/tickets/#{ticket.id}"

    click_link 'Capture'

    expect(ticket.reload.organization).to eq(org)
    expect(page).to have_current_path('/dashboard', ignore_query: true)
  end
end