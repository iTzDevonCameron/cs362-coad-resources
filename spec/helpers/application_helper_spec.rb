require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "full title method" do
    let (:helper) { Object.new.extend(ApplicationHelper) }   
    it "returns a title name when not blank" do
      title = helper.full_title("Full Test Title")
      expect(title).to eq "Full Test Title | Disaster Resource Network"
    end
    it "returns a title name when blank" do
      title = helper.full_title("")
      expect(title).to eq "Disaster Resource Network"
    end
  end
end