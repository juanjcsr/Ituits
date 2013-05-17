namespace :db do
  desc "Llenar la base de datos con datos de ejemplo"
  task llenar: :environment do
    admin = User.create!( name: "Juan Carlos",
                  email: "jjuanchow@gmail.com",
                  password: "juancho",
                  password_confirmation: "juancho")
    admin.toggle!(:admin)
    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password = "password"
      User.create!( name: name,
                    email: email,
                    password: password,
                    password_confirmation: password)
    end
  end
end