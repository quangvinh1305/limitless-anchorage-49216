class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @cart = current_cart
    if @cart.line_items.empty?
      redirect_to root_url
      flash[:danger] = "your cart is empty"
    end

    @order = Order.new
    if logged_in?
      user = current_user
      @order[:name] = user.name
      @order[:email] = user.email
      @order[:address] = user.adress
      @order[:phone_number] = user.phone_number
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
    if logged_in?
      @order.user_id = current_user.id
    end   
    if @order.save
      Cart.destroy(session[:cart_id])
      session[:cart_id] = nil
      OrderWorker.perform_async(@order.id)
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
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
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
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:name, :address, :email, :pay_type, :phone_number)
    end
end
