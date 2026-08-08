FactoryBot.define do
  factory :expense do
    description { "Sample expense" }
    amount { 9.99 }
    date { Date.current }
    category
  end
end
