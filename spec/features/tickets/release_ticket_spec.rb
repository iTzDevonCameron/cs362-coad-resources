require 'rails_helper'

RSpec.describe 'Releasing a ticket', type: :feature do
  scenario 'Approved organization user releases a ticket they captured' do
    org = create_approved_organization
    user = create_confirmed_user(email: 'releaser@example.com', organization: org)
    ticket = create_ticket_record(name: 'Release Test', organization: org)

    sign_in_as(user)
    visit "/tickets/#{ticket.id}"

    click_link 'Release'

    expect(ticket.reload.organization).to be_nil
    expect(page).to have_current_path('/dashboard', ignore_query: true)
  end
end