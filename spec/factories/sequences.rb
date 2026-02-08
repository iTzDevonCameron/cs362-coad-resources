FactoryBot.define do
  sequence :emails do |n|
    "fakeuser{n}@fakedomain{n}.com"
  end

  sequence :password do |n|
    "fakepassword#{n}"
  end

  sequence :phone do |n|
    "+1-555-" + ("%04d" % n) # or...
    # "+1-555-" + n.to_s.rjust(4, "0")
  end

  sequence :name do |n|
    "fakename_#{n}"
  end

  sequence :organization do |n|
    "fakeorganization_#{n}"
  end

  sequence :description do |n|
    "fakedescription_#{n}"
  end
end