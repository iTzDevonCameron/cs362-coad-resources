require 'rails_helper'

RSpec.describe 'Closing a ticket', type: :feature do
  scenario 'Approved organization user closes a captured ticket' do
    org = create_approved_organization
    user = create_confirmed_user(email: 'closer@example.com', organization: org)
    ticket = create_ticket_record(name: 'Close Test', organization: org)

    sign_in_as(user)
    visit "/tickets/#{ticket.id}"

    click_link 'Close'

    expect(ticket.reload).to be_closed
    expect(page).to have_current_path('/dashboard', ignore_query: true)
  end
end