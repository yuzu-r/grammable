FactoryGirl.define do
  factory :comment do
    message "wow"    
  end
  factory :user do
    sequence :email do |n|
      "dummyEmail#{n}@example.com"
    end
    password "password"
    password_confirmation "password"
  end

  factory :gram do
    message "hello"
    picture { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'smiley.png'), 'image/png') }
    association :user
  end

end