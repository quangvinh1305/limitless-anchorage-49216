require_relative '../config/environment'
require 'rails_helper'
require 'capybara'
require 'capybara/dsl'
feature "Module 3 Buying Feature", :type => :routing do
  let!(:product_first){Category.first.included_products.where("stock > 0").first}

  scenario "Allow user add cart and clear cart" do
    visit root_path
    first('input[type="submit"]').click
    expect(page).to have_content "Line item was successfully created."
    expect(page).to have_content "#{product_first.title}"
    expect(page).to have_content "#{product_first.price}"
    expect(page).to have_content "Continue Shopping"
    expect(page).to have_content "Clear Cart"
    expect(page).to have_content "Checkout"
    expect(page).to have_content "Remove"
    click_on "Clear"
    expect(page.status_code).to eq(200)
    expect(page).to have_content "Cart was successfully destroyed."
  end

  scenario "Allow user add cart and Checkout cart" do
    visit root_path
    first('input[type="submit"]').click
    expect(page).to have_content "Line item was successfully created."
    expect(page).to have_content "#{product_first.title}"
    expect(page).to have_content "#{product_first.price}"
    expect(page).to have_content "Continue Shopping"
    expect(page).to have_content "Clear Cart"
    expect(page).to have_content "Checkout"
    expect(page).to have_content "Remove"
    click_on "Checkout"
    expect(page.status_code).to eq(200)
    fill_in 'order[name]', with: "nguyen quang vinh"
    fill_in 'order[address]', with: "15/14 Vo Duy Ninh"
    fill_in 'order[email]', with: "quangvinh.1305@gmail.com"
    fill_in 'order[phone_number]', with: "0938112266"
    select "Check", from: "order_pay_type"
    click_on "Create Order"
    expect(page).to have_content "Order was successfully created."
  end

end