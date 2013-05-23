FactoryGirl.define do 
	factory :user do
    sequence(:name) { |n| "Persona #{n}" }
    sequence(:email) { |n| "persona_#{n}@example1.com"}
    sequence(:username) { |n| "persona#{n}" }
    password "password"
    password_confirmation "password"

    factory :admin do
      admin true
    end
  end

  factory :minituit do
    content "Lorem ipsum"
    user
  end

end