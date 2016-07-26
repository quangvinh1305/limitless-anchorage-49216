require_relative '../config/environment'
require 'rails_helper'
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

feature "Module 5 Stock management Feature", :type => :routing do
  let!(:product_first){Category.first.included_products.where("stock > 0").first}

  scenario "Invalid stock", :js => true do
    visit root_path
    first('input[value="Add to cart"]').click
    expect(page).to have_content "Line item was successfully created."
    expect(page).to have_content "#{product_first.title}"
    expect(page).to have_content "#{product_first.price}"
    expect(page).to have_content "Continue Shopping"
    expect(page).to have_content "Clear Cart"
    expect(page).to have_content "Checkout"
    expect(page).to have_content "Remove"
    fill_in "quantity", with: "-100"
    page.execute_script("$('#quantity').trigger('change')")
    expect(page).to have_content "#{product_first.title} is invalid quantity"
    fill_in "quantity", with: product_first.stock + 1
    page.execute_script("$('#quantity').trigger('change')")
    expect(page).to have_content "We just have #{product_first.stock}: #{product_first.title}"
  end

  scenario "valid stock", :js => true do
    visit root_path
    first('input[value="Add to cart"]').click
    expect(page).to have_content "Line item was successfully created."
    expect(page).to have_content "#{product_first.title}"
    expect(page).to have_content "#{product_first.price}"
    expect(page).to have_content "Continue Shopping"
    expect(page).to have_content "Clear Cart"
    expect(page).to have_content "Checkout"
    expect(page).to have_content "Remove"
    fill_in "quantity", with: "#{product_first.stock}"
    page.execute_script("$('#quantity').trigger('change')")
    click_on 'Checkout'
    expect(current_path).to eq(new_order_path)
  end
end