require 'rails_helper'

RSpec.describe 'Logging in', type: :feature do
  scenario 'User logs into the system' do
    user = create_confirmed_user(email: 'test@example.com')

    visit '/users/sign_in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password123'
    click_button 'Sign in'

    expect(page).to have_content('Dashboard')
  end
end