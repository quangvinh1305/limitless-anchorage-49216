class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :admin_authentication, only: [:admin, :edit]

  # GET /orders
  # GET /orders.json
  def index
    if logged_in?
      @orders = current_user.orders
    else
      set_order
    end
  end

  def admin
    @orders = Order.all
  end
  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @cart = current_cart
    line_items = @cart.line_items
    if line_items.empty?
      flash[:alert] = "your cart is empty"
      redirect_to root_url
    elsif line_items.any? { |item| item.product.stock <= 0 }
      flash[:alert] = "Out of stock"
      redirect_to root_path
    elsif line_items.any? { |item| item.quantity > item.product.stock }
      flash[:alert] = "Item execeeds stock"
      redirect_to cart_url
    else
      @order = Order.new
      if logged_in?
        user = current_user
        @order[:name] = user.name
        @order[:email] = user.email
        @order[:address] = user.address
        @order[:phone_number] = user.phone_number
      end    
    end

    
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    @cart = current_cart;
    @order.add_line_items_from_cart(@cart)
    line_items = @order.line_items;

    if line_items.any? { |item| item.product.stock <= 0 }
      redirect_to root_url, 
      flash[:alert] = "Item is out of stock"
      line_items.each { |item| item.destroy if item.product.stock <= 0 }
      return
    end

    if logged_in?
      @order.user_id = current_user.id
    end

    if @order.save
      @order.remove_product_in_stock
      Cart.destroy(session[:cart_id])
      session[:cart_id] = nil
      send_order_email(@order)
      flash[:success] = 'Order was successfully created.' 
      redirect_to root_path

    else
      @cart = current_cart
      flash.now[:danger] = "Please try"
      render :new 
    end
    
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update

    status = params[:status].to_i
    if status < 0 && status >5
      flash[:warning] = "Invalid status"
      redirect_to admin_path
      return
    end
    respond_to do |format|
      if @order.update_attributes(status: status)
        redirect_to admin_path 
        flash[:success] = 'Order was successfully updated.'
      else
        redirect_to admin_path 
        flash[:warning] = 'Order was successfully updated.'
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def admin_authentication
      if logged_in?
        if !current_user.admin?
          flash[:danger] = "You don't have permission for this page";
          redirect_to login_path
        end
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:name, :address, :email, :pay_type,  :phone_number)
    end
end
