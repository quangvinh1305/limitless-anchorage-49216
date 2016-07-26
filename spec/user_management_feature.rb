require_relative '../config/environment'
require 'rails_helper'
require 'capybara'
require 'capybara/dsl'

feature "Module 2 User Management Feature", :type => :routing do
  include Capybara::DSL
  context "Testing for user management feature" do
    let!(:admin){User.find_by_email "quangvinh.1305@gmail.com"}

    scenario "Show contents of sign up page" do
      visit (root_path)
      click_link("Sign Up")
      expect(page.status_code).to eq(200)
      expect(page).to have_content("Sign up")
      expect(page).to have_field("user[name]")
      expect(page).to have_field("user[email]")
      expect(page).to have_field("user[password]")
      expect(page).to have_field("user[password_confirmation]")
      expect(page).to have_button("Create my account")
    end

    scenario "Missing all field on page" do
      visit (root_path)
      click_link("Sign Up")
      expect(page.status_code).to eq(200)
      click_on 'Create my account'
    end

    scenario "Missing username field on page" do
      visit (root_path)
      click_link("Sign Up")
      expect(page.status_code).to eq(200)
      fill_in 'user[email]', with: "Test@email.com"
      fill_in 'user[password]', with: "dsjdkskdkjsdkjds"
      fill_in 'user[password_confirmation]', with: "dsjdkskdkjsdkjds"
      fill_in 'user[phone_number]', with: "0938112266"
      fill_in 'user[address]', with: "dskjdsjksdkjdskjdsjkdskj"
      click_on 'Create my account'
      expect(page).to have_content "Name can't be blank"
    end
    scenario "Invalid email field on page" do
      visit (root_path)
      click_link("Sign Up")
      expect(page.status_code).to eq(200)
      fill_in 'user[name]', with: "exampleuser"
      fill_in 'user[password]', with: "dsjdkskdkjsdkjds"
      fill_in 'user[password_confirmation]', with: "dsjdkskdkjsdkjds"
      fill_in 'user[phone_number]', with: "0938112266"
      fill_in 'user[address]', with: "dskjdsjksdkjdskjdsjkdskj"
      click_on 'Create my account'
      expect(page).to have_content "Email can't be blank"
      expect(page).to have_content "Email is invalid"
    end
    scenario "Signup success" do
      visit (root_path)
      click_link("Sign Up")
      expect(page.status_code).to eq(200)
      fill_in 'user[name]', with: "exampleuser"
      fill_in 'user[email]', with: "exampleuser@gmail.com"
      fill_in 'user[password]', with: "dsjdkskdkjsdkjds"
      fill_in 'user[password_confirmation]', with: "dsjdkskdkjsdkjds"
      fill_in 'user[phone_number]', with: "0938112266"
      fill_in 'user[address]', with: "dskjdsjksdkjdskjdsjkdskj"
      click_on 'Create my account'
      expect(page).to have_content "Please check your email to activate your account."
    end

    scenario "Invalid user or password" do
      visit (logout_path)
      visit (root_path)
      click_link("Log in")
      expect(page.status_code).to eq(200)
      fill_in 'session[email]', with: "quanvinh.1305@gmail.com"
      fill_in 'session[password]', with: "nguyenlethienthu"
      click_button 'Log in'
      expect(page).to have_content "Invalid email/password combination"
    end

    scenario "Login success" do
      visit (logout_path)
      visit (root_path)
      click_link("Log in")
      expect(page.status_code).to eq(200)
      fill_in 'session[email]', with: "quangvinh.1305@gmail.com"
      fill_in 'session[password]', with: "nguyenlethienthu"
      click_button 'Log in'
      expect(page.status_code).to eq(200)
      expect(page).to have_content "#{admin.name}"
      visit (logout_path)
    end
  end

end