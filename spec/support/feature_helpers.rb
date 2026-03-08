module FeatureHelpers
  def valid_org_attributes(overrides = {})
    {
      name: 'Helping Hands',
      email: 'org@example.com',
      phone: '541-398-3298',
      description: 'Community support organization',
      primary_name: 'Doe, Jane',
      secondary_name: 'Smith, John',
      secondary_phone: '555-555-5555',
      title: 'Director',
      transportation: :yes,
      liability_insurance: true
    }.merge(overrides)
  end

  def create_approved_organization(overrides = {})
    Organization.create!(valid_org_attributes({ status: :approved }.merge(overrides)))
  end

  def create_submitted_organization(overrides = {})
    Organization.create!(valid_org_attributes({ status: :submitted }.merge(overrides)))
  end

  def create_confirmed_user(overrides = {})
    defaults = {
      email: 'user@example.com',
      password: 'password123',
      password_confirmation: 'password123',
      confirmed_at: Time.current
    }
    User.create!(defaults.merge(overrides))
  end

  def create_admin_user(overrides = {})
    create_confirmed_user({ email: 'admin@example.com', role: :admin }.merge(overrides))
  end

  def sign_in_as(user, password: 'password123')
    visit '/login'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: password
    click_button 'Sign in'
  end

  def create_ticket_record(overrides = {})
    region = overrides.delete(:region) || Region.create!(name: "Region #{SecureRandom.hex(2)}")
    resource_category = overrides.delete(:resource_category) || ResourceCategory.create!(name: "Category #{SecureRandom.hex(2)}")

    Ticket.create!({
      name: 'Needs Food',
      description: 'Need help with groceries',
      phone: '+15414541232',
      region: region,
      resource_category: resource_category
    }.merge(overrides))
  end
end

RSpec.configure do |config|
  config.include FeatureHelpers, type: :feature
end