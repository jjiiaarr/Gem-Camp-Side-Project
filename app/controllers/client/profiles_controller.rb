class Client::ProfilesController < ApplicationController

  before_action :set_user, only: :edit

  def show
    @user = current_user
    @order_history = Order.where(user: @user).limit(5).order(created_at: :desc) if params[:order] == 'order'
    @lottery_history = @user.bets.limit(5).order(created_at: :desc) if params[:lottery] == 'lottery'
    @winner_history = Winner.where(user: @user).order(created_at: :desc) if params[:winner] == 'winner'
    @invitation_history = User.where(parent: @user).order(created_at: :desc) if params[:invitation] == 'invitation'
  end

  def cancel
    @order = current_user.orders.find(params[:format])
    if @order.may_cancel?
      @order.cancel!
      flash[:notice] = "Order canceled"
    else
      flash[:alert] = "Order failed to cancel"
    end
    redirect_to client_profile_path
  end

  def edit; end

  private

  def set_user
    @user = current_user
  end

end
