Given /^a user visits the login page$/ do
  visit login_path
end

When(/^he submits invalid login information$/) do
  click_button "Iniciar"
end

Then(/^he should see an error message$/) do
  page.should have_selector('div.alert.alert-error')
end

Given /^the user has an account$/ do
  @user = User.create(name: "Example User", email: "user@example.com",
                      password: "foobar", password_confirmation: "foobar")
end

When /^the user submits valid login information$/ do
  fill_in "Email",    with: @user.email
  fill_in "Password", with: @user.password 
  click_button "Iniciar"
end

Then /^he should see his profile page$/ do
  page.should have_selector('title', text: @user.name)
end

Then /^he should see a signout link$/ do
  page.should have_link('Salir', href: logout_path)
end