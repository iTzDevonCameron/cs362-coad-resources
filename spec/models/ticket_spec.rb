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
end
