require 'spec_helper'

module MessagesSpecHelper
  def build_message
    m = Message.instance
    m.from = Faker::Internet.email
    m.to = Faker::Internet.email
    m.subject = Faker::Hacker.adjective.capitalize + ' ' + Faker::Hacker.noun
    m.body = Faker::Hacker.say_something_smart
    m
  end
end
