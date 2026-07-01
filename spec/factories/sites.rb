FactoryBot.define do
  factory :site do
    name { "Test Site" }
    domain { "https://cdn.example.com" }
    path { "/api/v1/resources" }
    port { nil }
    structure_path { "internal/api/v1/structures" }
    api_token { "test-jwt-token" }

    trait :with_port do
      port { "8443" }
    end
  end
end
