class Client::LotteryController < ApplicationController
  def index

    @categories = Category.all
    @selected_category = params[:category_id]
    @items = Item.active.starting
    @items = @items.where(category_id: @selected_category) if @selected_category.present?
  end
end
