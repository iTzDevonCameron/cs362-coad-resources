require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the TIcketsHelper. For example:
#
# describe TIcketsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe TicketsHelper, type: :helper do
  describe "Formats the phone number" do
    let (:helper) { Object.new.extend(TicketsHelper) }
    it "returns a formatted phone number (+1-111-111-1111)" do
      expect(helper.format_phone_number('5555555555')).to eq "+15555555555"
    end
  end
end
