FactoryBot.define do
  factory :message, class: 'Message' do
    feed
    sequence(:from) {Faker::Internet.email}
    sequence(:to) {Faker::Internet.email}
    sequence(:subject) {Faker::Hacker.adjective.capitalize + ' ' + Faker::Hacker.noun}
    sequence(:body) {Faker::Hacker.say_something_smart}
  end
end
