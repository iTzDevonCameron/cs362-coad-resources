require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "#new_organization_application" do
    let(:new_organization) do
      double("Organization", primary_name: "Jane Doe", name: "My Org")
    end

    let(:params) do
      {
        to: "person@example.com",
        new_organization: new_organization
      }
    end

    it "sends the email in test environment" do
      mail = described_class.with(params).new_organization_application.message

      expect(mail).to be_a(Mail::Message)
      expect(mail.to).to eq(["person@example.com"])
      expect(mail.subject).to eq("New Organization Application Pending")
    end

    it "returns a null mail outside production and test" do
      allow(Rails).to receive(:env)
        .and_return(ActiveSupport::StringInquirer.new("development"))

      mail = described_class.with(params).new_organization_application.message

      expect(mail).to be_a(ActionMailer::Base::NullMail)
    end
  end
end
