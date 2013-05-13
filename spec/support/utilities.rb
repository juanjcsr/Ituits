def log_in(user)
  visit login_path
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Iniciar"

  #Sign in when not using Capybara
  #post sessions_path, :email => user.email, :password => user.password, :password_confirmation => user.password
  #Session#create requiere un nested hash!!!
  post sessions_path, :session => { :email => "jjuanchow@gmail.com", :password => "juancho" }
end