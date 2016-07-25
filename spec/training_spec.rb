require_relative 'rails_helper'
require 'pp'
describe "VenstoreShop App" do
  it "Display all product" do
    Capybara.default_max_wait_time = 15
    visit "/login"
    expect(page).to have_content 'Log in'
    expect(page).to have_content 'Email'
    expect(page).to have_content 'Password'
    expect(page).to have_content 'Remember me on this computer'
  end

end