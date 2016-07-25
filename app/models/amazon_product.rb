require 'ostruct'
class AmazonProduct

  def initialize
    @request = Vacuum.new
    @request.configure(
    aws_access_key_id: ENV['aws_access_key_id'],
    aws_secret_access_key: ENV['aws_secret_access_key'],
    associate_tag: ENV['associate_tag']
    )
    @solr = RSolr.connect url: 'http://localhost:8983/solr/development'
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
        responses = responses['ItemSearchResponse']['Items']['Item']
        responses[0..19].each do |item|
          return "Complete" if item == nil
          Product.find_or_create_by(pin: item["ASIN"]) do |product|
            if item["ItemAttributes"]["Title"] != nil
              product.title = item["ItemAttributes"]["Title"]
              if item["EditorialReviews"] != nil
                editorial_review = item["EditorialReviews"]["EditorialReview"]
                if editorial_review == nil
                  product.description = "This product has no description yet"
                elsif editorial_review.is_a? Array
                  product.description = editorial_review.first["Content"]
                else
                  product.description = editorial_review["Content"]
                end
              end
              product.price = item["ItemAttributes"]["ListPrice"] != nil ? item["ItemAttributes"]["ListPrice"]["Amount"].to_d / 100 : item["OfferSummary"]["LowestNewPrice"]["Amount"].to_d / 100
              product.category_id = category.id
              if item["LargeImage"] == nil
                if item["ImageSets"] != nil
                  product.remote_image_url = item["ImageSets"]["ImageSet"].is_a?(Array) ? item["ImageSets"]["ImageSet"].first["LargeImage"]["URL"] : item["ImageSets"]["ImageSet"]["LargeImage"]["URL"]
                else
                  product.remote_image_url = "https://images-na.ssl-images-amazon.com/images/G/01/x-site/icons/no-img-sm._V192198896_BO1,204,203,200_.gif"
                end
              else
                product.remote_image_url = item["LargeImage"]["URL"]
              end
              product.stock = rand(2..10)
              if product.save
                puts "#{product.title} is fetched and updated successfully"
                solr_product = {id: product.id, title: product.title, stock: product.stock, price: product.price,
                                description: product.description, pin: product.pin,
                                category_id: product.category_id, image_url: product.image_url}
                @solr.add solr_product
              end
            end
          end
        end
        @solr.update :data => '<commit/>'
        @solr.update :data => '<optimize/>'
      end
    end
  end

end


