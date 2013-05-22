namespace :db do
  desc "Llenar la base de datos con datos de ejemplo"
  task llenar: :environment do
    crear_usuarios
    crear_minituits
    crear_relaciones
  end
end

def crear_usuarios
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

def crear_minituits
  users = User.all(limit: 6)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.minituits.create!(content: content) }
  end
end

def crear_relaciones
  users = User.all
  user = users.second
  followed_users = users[3..50]
  followers = users[4..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end