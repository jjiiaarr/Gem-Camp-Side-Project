class Admin::ItemController < ApplicationController
  layout 'admin'

  before_action :set_item, only: [:edit, :update, :destroy]

  def index
    @items = Item.all
  end

  def new
    @item = Item.new
  end

  def edit
    @item = Item.find(params[:id])
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      flash[:notice] = "Item created successfully"
      redirect_to admin_item_index_path
    else
      flash[:alert] = "Item creation failed"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @item.update(item_params)
      flash[:notice] = 'Item updated successfully'
      redirect_to admin_item_index_path
    else
      flash.now[:alert] = 'Item update failed'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    flash[:notice] = 'Item deleted successfully'
    redirect_to admin_item_index_path
  end

  def start
    item = Item.find(params[:id])
    item.batch_count = 0
    if item.start!
      item.update(quantity: item.quantity - 1, batch_count: item.batch_count + 1)
      flash[:notice] = 'Item started'
    else
      flash[:alert] = 'Unable to start item'
    end
    redirect_to admin_item_index_path
  end

  def pause
    item = Item.find(params[:id])
    if item.pause!
      flash[:notice] = 'Item paused'
    else
      flash[:alert] = 'Unable to pause item'
    end
    redirect_to admin_item_index_path
  end

  def end
    item = Item.find(params[:id])
    if item.end!
      flash[:notice] = 'Item ended'
    else
      flash[:alert] = 'Unable to end item'
    end
    redirect_to admin_item_index_path
  end

  def cancel
    item = Item.find(params[:id])
    if item.cancel!
      flash[:notice] = 'Item cancelled'
    else
      flash[:alert] = 'Unable to cancel item'
    end
    redirect_to admin_items_index_path
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:image, :name, :quantity, :minimum_bets, :state, :batch_count, :online_at,
                                 :offline_at, :start_at, :status)
  end
end
