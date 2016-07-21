class SolrProduct

  def self.search_products query, page
    response = {}
    page = page.nil? ? 0 : page.to_i - 1
    response_hashed = SolrConnectionProducts.get 'select', :params => { :q => query,
                                                                        :start => page * 10,
                                                                        :rows => 10 }
    response['ids'] = response_hashed['response']['docs'].any? ? response_hashed['response']['docs'].map{ |x| x["id"]} : []
    response['total'] =  response_hashed['response']['numFound'].to_i
    response
  end

  def self.add_product products
    SolrConnectionProducts.add products
    SolrConnectionProducts.update :data => '<commit/>'
    SolrConnectionProducts.update :data => '<optimize/>'
  end
end

