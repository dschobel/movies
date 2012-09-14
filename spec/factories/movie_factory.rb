FactoryGirl.define do
    factory :movie do
        director "Inception"
        title  "Christopher Nolan"
        description "a very good movie"
        release_date 3.years.ago
    end
end
