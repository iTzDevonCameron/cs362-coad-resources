require 'rails_helper'

RSpec.describe 'Creating an Organization Application', type: :feature do
  scenario 'User submits an organization application' do
    create_admin_user(email: 'admin@example.com')
    category = ResourceCategory.create!(name: 'Food')
    user = create_confirmed_user(email: 'applicant@example.com')

    sign_in_as(user)
    visit '/new_organization_application'

    choose 'organization_liability_insurance_true'
    choose 'organization_agreement_one_true'
    choose 'organization_agreement_two_true'
    choose 'organization_agreement_three_true'
    choose 'organization_agreement_four_true'
    choose 'organization_agreement_five_true'
    choose 'organization_agreement_six_true'
    choose 'organization_agreement_seven_true'
    choose 'organization_agreement_eight_true'

    fill_in 'What is your name? (Last, First)', with: 'Applicant, Avery'
    fill_in 'Organization Name', with: 'Test Org'
    fill_in 'What is your title? (if applicable)', with: 'Coordinator'
    fill_in 'What is your direct phone number? Cell phone is best.', with: '541-398-3298'
    fill_in "Who may we contact regarding your organization's application if we are unable to reach you?", with: 'Backup, Bailey'
    fill_in 'What is a good secondary phone number we may reach your organization at?', with: '555-555-5555'
    fill_in "What is your Organization's email?", with: 'org@test.com'

    find("input[type='checkbox'][value='#{category.id}']", visible: false).set(true)

    fill_in 'Description', with: 'Testing org'
    choose 'organization_transportation_yes'

    click_button 'Apply'

    expect(page).to have_content('Application Submitted')
    expect(Organization.last.name).to eq('Test Org')
    expect(user.reload.organization).to eq(Organization.last)
  end
end