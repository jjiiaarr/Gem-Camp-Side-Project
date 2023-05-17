class Admin::BetsController < ApplicationController

  layout 'admin'
  def index
    @bets = Bet.includes(:user, :item).all.order(created_at: :desc)
    @bets = @bets.filter_by_serial_number(params[:serial_number]) if params[:serial_number].present?
    @bets = @bets.filter_by_item_name(params[:item_name]) if params[:item_name].present?
    @bets = @bets.filter_by_email(params[:email]) if params[:email].present?
    @bets = @bets.filter_by_state(params[:state]) if params[:state].present?
    @bets = @bets.filter_by_date_range(params[:start_date].to_date..params[:end_date].to_date) if params[:start_date].present? && params[:end_date].present?
  end
end
