class LineItemsController < ApplicationController
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]

  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items
  # POST /line_items.json
  def create
    @cart = current_cart
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product.id)
      if @line_item.save
        redirect_to @cart
        flash[:success] = 'Line item was successfully created.'
      else
        render "new"
      end

  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    @line_item = LineItem.find(params[:id])
    quant = params[:quantity].to_i
    warning_message = nil

    if quant > @line_item.product.stock
      quant = @line_item.product.stock
      warning_message = "We just have #{@line_item.product.stock}: #{@line_item.product.title}"
    end
    if quant <= 0
      flash[:warning] = @line_item.product.title + ' is invalid quantity.'
      redirect_to current_cart
      return
    end
    if @line_item.update_attributes(quantity: quant)
      flash[:success] = warning_message.nil? ? "#{@line_item.product.title} is successfully updated" : warning_message
      redirect_to current_cart
    else
      flash[:warning] = '#{@line_item.product.title} is not updated.'
      redirect_to current_cart
    end

  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    cart = current_cart
    if cart.line_items.empty?
      redirect_to root_path
      flash[:warning] = "Your cart is empty now. So you can't clear it"
      return
    end
    @line_item.destroy
    if cart.line_items.empty?
      redirect_to root_path
      flash[:warning] = "Cart is successfully updated. Countinue shopping now."
    else
      flash[:success] = "Cart is successfully updated."
      redirect_to cart
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def line_item_params
      #params.require(:line_item).permit(:product_id, :cart_id, :quantity, :order_id)
    end
end
