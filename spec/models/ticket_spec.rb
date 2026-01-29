require 'rails_helper'

RSpec.describe Ticket, type: :model do
    it "exists" do
        Ticket.new
    end

    let (:ticket) { Ticket.new }

    it "responds to name" do
        expect(ticket).to respond_to(:name)
        expect(ticket).to respond_to(:description)
    end

    it "Belongs to region" do
        should belong_to(:region)
    end

    # For optional reasons
    it "Belongs to region" do
        should belong_to(:organization).optional
    end

    describe "validation tests" do
        #let (:ticket) { Ticket.new }
        subject { Ticket.new }

        it "must have a name" do
            #expect(ticket).to validate_presence_of(:name)
            should validate_presence_of(:name)
        end

        it "must validate phone numbers" do
            should allow_value('+1-555-555-5555').for(:phone)
            #should_not allow_value(...)
        end
    end
    describe "Member function tests" do
        let (:ticket_123) { Ticket.new(id: 123) }

        it "converts to a string" do
            expect(ticket_123.to_s).to eq "Ticket 123"
        end
    end

    describe "scope tests" do
        let (:ticket)do
            t = Ticket.new
            t.save(validate: false)
            t
        end

        let (:closed_ticket)do
            t = Ticket.new(closed: true)
            t.save(validate: false)
            t
        end

        it "scopes open-tickets" do
            expect(Ticket.open).to include(ticket)
        end

        it "scopes closed-tickets" do
            expect(Ticket.closed).to include(closed_ticket)
        end
    end

    describe "#open?" do
      it "is true when not closed" do
        ticket.closed = false
        expect(ticket.open?).to be true
      end

      it "is false when closed" do
        ticket.closed = true
        expect(ticket.open?).to be false
      end
    end

    describe "#captured?" do
      it "is false when no organization" do
        ticket.organization = nil
        expect(ticket.captured?).to be false
      end

      it "is true when organization present" do
        # ticket.organization = build(:organization)
        ticket.organization = Organization.new
        expect(ticket.captured?).to be true
      end
    end

    describe "#to_s" do
      it "returns Ticket <id>" do
        ticket.id = 123
        expect(ticket.to_s).to eq("Ticket 123")
      end
    end
end
