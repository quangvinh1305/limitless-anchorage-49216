class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    if logged_in?
      add_breadcrumb "home", root_path
      add_breadcrumb "Products"
      @products = Product.where user_id: current_user.id
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    @product.user_id = current_user.id
    respond_to do |format|
      if @product.save
        SolrProduct.add_product ({:id => @product.id, :title => @product.title, :stock => @product.stock, :price => @product.price,
                                  :description => @product.description, :pin => @product.pin,
                                  :category_id => @product.category_id, :image_url => @product.image_url})  
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def search
    add_breadcrumb "home", root_path
    add_breadcrumb "search"
    @solr_search = SolrProduct.search_products params[:search], params[:page]
    product_ids = @solr_search['response']['docs'].any? ? @solr_search['response']['docs'].map{ |x| x["id"]} : []
    @total_results = @solr_search['response']['numFound'].to_i
    @products = product_ids.any? ? Product.where(id: product_ids) : []
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:title, :description, :image, :price, :category_id, :stock)
    end
end
