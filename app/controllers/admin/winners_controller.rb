class Admin::WinnersController < ApplicationController
  before_action :set_winner, except: :index

  layout 'admin'

  def index
    @winners = Winner.includes(:user, :item, :bet).all
    @winners = @winners.filter_by_serial_number(params[:serial_number]) if params[:serial_number].present?
    @winners = @winners.filter_by_item_name(params[:item_name]) if params[:item_name].present?
    @winners = @winners.filter_by_email(params[:email]) if params[:email].present?
    @winners = @winners.filter_by_state(params[:state]) if params[:state].present?
    @winners = @winners.filter_by_date_range(params[:start_date].to_date..params[:end_date].to_date) if params[:start_date].present? && params[:end_date].present?
  end

  def submit
    if @winner.may_submit?
      @winner.submit!
      flash[:notice] = 'State submitted successfully'
    else
      flash[:alert] = 'State not submitted'
    end
    redirect_to admin_winners_path
  end

  def pay
    if @winner.may_pay?
      @winner.pay!
      flash[:notice] = 'State paid successfully'
    else
      flash[:alert] = 'State not paid'
    end
    redirect_to admin_winners_path
  end

  def ship
    if @winner.may_ship?
      @winner.ship!
      flash[:notice] = 'State shipped successfully'
    else
      flash[:alert] = 'State not shipped'
      ship
      redirect_to admin_winners_path
    end
  end

  def deliver
    if @winner.may_deliver?
      @winner.deliver!
      flash[:notice] = 'State delivered successfully'
    else
      flash[:alert] = 'State not delivered'
    end
    redirect_to admin_winners_path
  end

  def publish
    if @winner.may_publish?
      @winner.publish!
      flash[:notice] = 'State published successfully'
    else
      flash[:alert] = 'State not published'
    end
    redirect_to admin_winners_path
  end

  def remove_publish
    if @winner.may_remove_publish?
      @winner.remove_publish!
      flash[:notice] = 'State remove_published successfully'
    else
      flash[:alert] = 'State not remove_published'
    end
    redirect_to admin_winners_path
  end

  private

  def set_winner
    @winner = Winner.find(params[:id])
  end
end
