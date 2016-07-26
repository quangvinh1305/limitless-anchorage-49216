require_relative '../config/environment'
require 'rails_helper'
require 'capybara'
require 'capybara/dsl'

feature "Module 1 Item Posting Feature", :type => :routing do
  include Capybara::DSL
  context "Scaffolding links and functions are in place and operational" do
    let!(:product){Product.first}
    let!(:categories){Category.all}
    let!(:admin){User.find_by_email "quangvinh.1305@gmail.com"}
    scenario "links to home, help and contacts, categories" do
      visit (root_path)
      expect(page.status_code).to eq(200)
      expect(page).to have_content("#{categories.first.title}")
      expect(page).to have_content("#{categories.last.title}")
      expect(page).to have_content("#{product.title}")
      expect(page).to have_link("Home", :href => "#{root_path}")
      expect(page).to have_link("About", :href => "#{about_path}")
      expect(page).to have_link("Help", :href => "#{help_path}")
      expect(page).to have_link("Contact", :href => "#{contact_path}")
      expect(page).to have_link("#{categories.first.title}", :href => "#{category_path(categories.first)}")
    end

    scenario "Show Category and products" do
      visit (root_path)
      click_link(categories.first.title, :href => "#{category_path(categories.first)}")
      expect(page.status_code).to eq(200)
      expect(page).to have_content("#{categories.first.title}")
      expect(page).to have_content("#{categories.first.products.first.title}")
    end
    scenario "Show Products details" do
      visit (root_path)
      click_link(product.title, :href => "#{product_path(product)}")
      expect(page.status_code).to eq(200)
      expect(page).to have_content("#{product.title}")
      expect(page).to have_content("#{product.price}")
    end

    scenario "login and create products" do
      visit (logout_path)
      visit (root_path)
      click_link("Log in", :href => "#{login_path}")
      expect(page.status_code).to eq(200)
      fill_in 'session[email]', with: "quangvinh.1305@gmail.com"
      fill_in 'session[password]', with: "nguyenlethienthu"
      click_button 'Log in'
      expect(page.status_code).to eq(200)
      expect(page).to have_content "#{admin.name}"
      click_link("products", :href => "#{products_path}")
      click_link("New Product", :href => "#{new_product_path}")
      expect(page.status_code).to eq(200)
      fill_in 'product[title]', with: "Example Products"
      fill_in 'product[description]', with: "Description Example"
      attach_file 'product[image]', Rails.root + "spec/fixtures/test.jpg"
      fill_in 'product[price]', with: "23"
      fill_in 'product[stock]', with: "10"
      select 'History', from: "product_category_id"
      click_button "Create New Product"
      expect(page.status_code).to eq(200)
      expect(page).to have_content "Example Products"
      expect(page).to have_content "Description Example"
      expect(page).to have_content "23"
    end

    end

end