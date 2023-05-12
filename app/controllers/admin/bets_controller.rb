class Admin::BetsController < ApplicationController
  def index
    @bets = Bet.all
    @bets = @bets.filter_by_serial_number(params[:serial_number]) if params[:serial_number].present?
    @bets = @bets.filter_by_item_name(params[:item_name]) if params[:item_name].present?
    @bets = @bets.filter_by_email(params[:email]) if params[:email].present?
    @bets = @bets.filter_by_state(params[:state]) if params[:state].present?
    @bets = @bets.filter_by_date_range(params[:date_range]) if params[:date_range].present?
  end
end
