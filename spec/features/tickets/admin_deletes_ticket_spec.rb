require 'rails_helper'

RSpec.describe 'Deleting a Ticket', type: :feature do
  scenario 'Admin deletes a ticket' do
    admin = create_admin_user
    ticket = create_ticket_record(name: 'Delete Me')

    sign_in_as(admin)
    visit "/tickets/#{ticket.id}"

    page.driver.submit :delete, "/tickets/#{ticket.id}", {}

    expect(page).to have_content("Ticket #{ticket.id} was deleted.")
    expect(Ticket.where(id: ticket.id)).to be_empty
  end
end