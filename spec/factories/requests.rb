require 'faker'

FactoryGirl.define do
  factory :request, :class => ActionDispatch::Request do |r|    
    trait :wiselinks do
      after(:build) do |obj|
        obj.env['X-Wiselinks'] = Faker::Lorem.characters(10)
      end
    end

    trait :wiselinks_template do
      after(:build) do |obj|
        obj.env['X-Wiselinks'] = 'template'
      end
    end

    trait :wiselinks_partial do
      after(:build) do |obj|
        obj.env['X-Wiselinks'] = 'partial'
      end
    end


    initialize_with{ new(Rack::MockRequest.env_for('/')) }

    factory :wiselinks_request,   traits: [:wiselinks]
    factory :wiselinks_template_request,   traits: [:wiselinks_template]
    factory :wiselinks_partial_request,   traits: [:wiselinks_partial]
  end
end