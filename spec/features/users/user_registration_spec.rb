require 'rails_helper'

RSpec.describe 'User registration', type: :feature do
  scenario 'User creates an account' do
    visit '/users/sign_up'

    fill_in 'Email', with: 'newuser@example.com'
    fill_in 'Password', with: 'password123'
    fill_in 'Password confirmation', with: 'password123'

    click_button 'Sign up'

    expect(page).to have_content('confirmation link has been sent')
  end
end