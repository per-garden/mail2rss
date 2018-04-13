FactoryBot.define do
  factory :feed do
    sequence(:name) {Faker::App.name}
    count Random.rand(2...6)
  end
end
