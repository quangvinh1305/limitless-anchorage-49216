# This class is used to get data form amazon.
class SolrProduct
  def self.search_products query, page
    resp_results = {}
    @solr_search = SolrConnectionProducts.paginate page, 10,
                                    'select',
                                    params: { q: query }
    resp_results['ids'] = @solr_search['response']['docs'].any? ? @solr_search['response']['docs'].map{ |x| x["id"]} : []
    resp_results['total_results'] = @solr_search['response']['numFound'].to_i
  end

  def self.add_product products
    SolrConnectionProducts.add products
    SolrConnectionProducts.update data: '<commit/>'
    SolrConnectionProducts.update data: '<optimize/>'
  end
end
