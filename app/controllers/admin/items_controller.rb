class Admin::ItemsController < ApplicationController
  layout 'admin'

  before_action :set_item, except: [:index, :new, :create]

  def index
    @items = Item.includes(:categories).all
  end

  def new
    @item = Item.new
  end

  def edit; end

  def create
    @item = Item.new(item_params)
    if @item.save
      flash[:notice] = "Item created successfully"
      redirect_to admin_items_path
    else
      flash[:alert] = "Item creation failed"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @item.update(item_params)
      flash[:notice] = 'Item updated successfully'
      redirect_to admin_items_path
    else
      flash.now[:alert] = 'Item update failed'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    flash[:notice] = 'Item deleted successfully'
    redirect_to admin_items_path
  end

  def start
    @item.batch_count = 0
    if @item.may_start?
      @item.start!
      @item.update(quantity: @item.quantity - 1, batch_count: @item.batch_count + 1)
      flash[:notice] = 'Item started'
    else
      flash[:alert] = 'Unable to start items'
    end
    redirect_to admin_items_path
  end

  def pause
    if @item.may_pause?
      @item.pause!
      flash[:notice] = 'Item paused'
    else
      flash[:alert] = 'Unable to pause items'
    end
    redirect_to admin_items_path
  end

  def end
    if @item.may_end?
      @item.end!
      flash[:notice] = 'Item ended'
    else
      flash[:alert] = 'Unable to end items'
    end
    redirect_to admin_items_path
  end

  def cancel
    if @item.may_cancel?
      @item.cancel!
      flash[:notice] = 'Item cancelled'
    else
      flash[:alert] = 'Unable to cancel items'
    end
    redirect_to admin_items_path
  end

  private

  def set_item
    @item = Item.find(params[:id] || params[:item_id])
  end

  def item_params
    params.require(:item).permit(:image, :name, :quantity, :minimum_bets, :online_at,
                                 :offline_at, :start_at, :status, category_ids: [])
  end
end
