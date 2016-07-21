class SolrProduct

  def self.search_products query, page
    response_hashed = {}
    response_hashed = SolrConnectionProducts.paginate page, 10, 'select', :params => { :q => query}
  end

  def self.add_product products
    SolrConnectionProducts.add products
    SolrConnectionProducts.update :data => '<commit/>'
    SolrConnectionProducts.update :data => '<optimize/>'
  end
end

