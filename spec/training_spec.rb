require_relative '../config/environment'
require 'rails_helper'
require 'capybara'
require 'capybara/dsl'

feature "Module 2 Item Posting Feature", :type => :routing do
    include Capybara::DSL
    context "Scaffolding links and functions are in place and operational" do 
        let!(:product){Product.first}
        let!(:categories){Category.all}

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
      end

    # context "Module 1 User Login Feature" do 
    #     let!(:product){Product.first}
    #     let!(:categories){Category.all}
    #     scenario "links to home, help and contacts, categories" do 
    #         visit (root_path) 
    #         expect(page.status_code).to eq(200)
    #         expect(page).to have_content("#{categories.first.title}")
    #         expect(page).to have_content("#{categories.last.title}")
    #         expect(page).to have_content("#{product.title}")
    #         expect(page).to have_link("Home", :href => "#{root_path}")
    #         expect(page).to have_link("About", :href => "#{about_path}")
    #         expect(page).to have_link("Help", :href => "#{help_path}")
    #         expect(page).to have_link("Contact", :href => "#{contact_path}")
    #         expect(page).to have_link("#{categories.first.title}", :href => "#{category_path(categories.first)}")
    #     end
    #   end

end