class Admin::OffersController < ApplicationController
  before_action :set_offer, only: [:edit, :update, :destroy]

  layout 'admin'
  def index
    @offers = Offer.all
    @offers = @offers.where(genre: params[:genre]) if params[:genre].present?
    @offers = @offers.where(status: params[:status]) if params[:status].present?
  end

  def new
    @offer = Offer.new
  end

  def create
    @offer = Offer.new(offer_params)
    if @offer.save
      flash[:notice] = "Offer successfully created"
      redirect_to admin_offers_path
    else
      render :new
    end
  end

  def edit; end

  def update
    @offer.update(offer_params)
    if @offer.save
      flash[:notice] = "Offer successfully updated"
      redirect_to admin_offers_path
    else
      render :edit
    end
  end

  def destroy
    @offer.destroy
    flash[:notice] = "Offer successfully deleted"
    redirect_to admin_offers_path
  end

  private

  def offer_params
    params.require(:offer).permit(:image, :name, :genre, :status, :amount, :coin)
  end

  def set_offer
    @offer = Offer.find(params[:id])
  end
end
