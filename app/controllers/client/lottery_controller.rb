class Client::LotteryController < ApplicationController
  def index
    @categories = Category.all
    @items = Item.includes(:categories).active.starting
    @items = @items.filter_by_category(params[:name]) if params[:name].present?
  end
end
