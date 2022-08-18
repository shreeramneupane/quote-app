FactoryBot.define do
  factory :quote do
    author { Faker::Name.name }
    title { Faker::Quote.matz }
  end
end
