class Client::LotteryController < ApplicationController
  def index
    @categories = Category.all
    @items = Item.includes(:categories).active.starting
    @items = @items.filter_by_category(params[:name]) if params[:name].present?
  end

  def show
    @bets = Bet.includes(:user, :item).all
    @item = Item.find(params[:id])
    @bet = Bet.new
    @client_serial_number = @bets.where(user: current_user, batch_count: @item.batch_count, item: @item)
    @item_batch_count = @item.bets.where(batch_count: @item.batch_count).count
    @progress_bars = [@item_batch_count / @item.minimum_bets * 100, 100].min.to_i
    @bet_count = @item.bets.where(batch_count: @item.batch_count).count
    @percentage_limit = @progress_bars
  end

  def create

    params[:bet][:coins] = 1
    params[:bet][:coins].to_i.times do
      @bet = Bet.new(item_params)
      @item = Item.find(params[:bet][:item_id])
      @bet.item = @item
      @bet.user = current_user
      @bet.batch_count = @item.batch_count

      if @bet.save
        flash[:notice] = "Bet successfully"
      else
        flash[:alert] = "Bet failed"
      end
    end

    redirect_to client_lottery_index_path
  end

  private

  def item_params
    params.require(:bet).permit(:coins, :item_id)
  end
end
