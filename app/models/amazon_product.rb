require 'vacuum'
require 'ostruct'
require 'pp'
class AmazonProduct

  def initialize
    @request = Vacuum.new
    @request.configure(
    aws_access_key_id:"AKIAIAJR65JO6EIPQWTA",
    aws_secret_access_key: "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",
    associate_tag: 'microv'
    )
  end

  def create_amz_products 
    Category.all.each do |category|
      (1..10).each do |page|
        responses = @request.item_search(
          query: {
            "ItemPage" => page.to_s,
            "SearchIndex" => "Books",
            "BrowseNode" => Category::CATEGORIES[category.title],
            "ResponseGroup" => "Medium, Images, Offers, EditorialReview"
        }).parse
        
        responses = responses['ItemSearchResponse']['Items']['Item'];

        responses[0..19].each do |item|
            return "Complete" if item == nil
          Product.find_or_create_by(pin: item["ASIN"]) do |product|
            product.title = item["ItemAttributes"]["Title"]
            editorial_review = item["EditorialReviews"]["EditorialReview"]
            if editorial_review == nil
              product.description = "This product has no description yet"
            elsif editorial_review.is_a? Array
              product.description = editorial_review.first["Content"]
            else
              product.description = editorial_review["Content"]
            end

            product.price = item["ItemAttributes"]["ListPrice"] != nil ? item["ItemAttributes"]["ListPrice"]["Amount"].to_d / 100 : item["OfferSummary"]["LowestNewPrice"]["Amount"].to_d / 100
            product.category_id = category.id
            if item["LargeImage"] == nil
              if item["ImageSets"] != nil  
                product.image_url = item["ImageSets"]["ImageSet"].is_a?(Array) ? item["ImageSets"]["ImageSet"].first["LargeImage"]["URL"] : item["ImageSets"]["ImageSet"]["LargeImage"]["URL"]
              else
                product.image_url = "https://images-na.ssl-images-amazon.com/images/G/01/x-site/icons/no-img-sm._V192198896_BO1,204,203,200_.gif"
              end
            else
              product.image_url = item["LargeImage"]["URL"]
            end
            product.stock = rand(2..10)
            puts "#{product.title} is fetched and updated successfully" if product.save
          end

        end
      end
    end

    # resp_hash['ItemSearchResponse']['Items']['Item'].each do |item| 
    #   amz_product = OpenStruct.new 
    #   n = n + 1
    #   p n
    #   amz_product.name = item['ItemAttributes']['Title'] 
      
    #   amz_product.image = item['LargeImage']['URL']
    #   amz_product.price = item['Offers']['Offer']
      

    #   amz_products << amz_product 
    # end
    # amz_products
  end

end
