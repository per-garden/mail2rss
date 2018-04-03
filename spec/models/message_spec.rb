require 'rails_helper'

RSpec.describe Message, type: :model do
  before(:all) do
    m = Message.instance
    m.from = Faker::Internet.email
    m.to = Faker::Internet.email
    m.subject = Faker::Hacker.adjective.capitalize + ' ' + Faker::Hacker.noun
    m.body = Faker::Hacker.say_something_smart
  end

  it "has a valid instance" do
    expect(Message.instance).to be_valid
  end

end
