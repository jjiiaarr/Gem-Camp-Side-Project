class Admin::OrdersController < ApplicationController
  before_action :set_order, only: [:pay, :cancel]
  before_action :set_user, only: [:new, :create]

  layout 'admin'

  def index
    @orders = Order.includes(:user, :offer).all
    @orders = @orders.where(serial_number: params[:serial_number]) if params[:serial_number].present?
    @orders = @orders.where(user: { email: params[:email] }) if params[:email].present?
    @orders = @orders.where(genre: params[:genre]) if params[:genre].present?
    @orders = @order.where(state: params[:state]) if params[:state].present?
    @orders = @order.where(offer: params[:offer]) if params[:offer].present?
    @orders = @orders.filter_by_date_range(params[:date_range]) if params[:date_range].present?
    @amount_sum = Order.sum(:amount)
    @coin_sum = Order.sum(:coin)
    @subtotal_amount = @orders.sum(:amount)
    @subtotal_coin = @orders.sum(:coin)
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.user = @user
    if @order.save
      if @order.submit! && @order.may_pay && @order.pay!
        flash[:notice] = "Order successfully created"
      else
        @order.cancel!
        flash[:alert] = "User Coins can't be deduct."
        render :new
      end
    else
      render :new
    end
    redirect_to admin_orders_path
  end

  def pay
    if @order.may_pay?
      @order.pay!
      flash[:notice] = "Order successfully paid"
    else
      flash[:alert] = "Order failed to pay"
    end
    redirect_to admin_orders_path
  end

  def cancel
    if @order.may_cancel?
      @order.cancel!
      flash[:notice] = "Order successfully cancelled"
    else
      flash[:alert] = "Order failed to cancel"
    end
    redirect_to admin_orders_path
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def order_params
    params.require(:order).permit(:coin, :remarks)
  end
end
