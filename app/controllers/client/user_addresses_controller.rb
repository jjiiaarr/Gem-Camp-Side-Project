class Client::UserAddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_address, only: [:edit, :update, :destroy]

  def index
    @user_addresses = current_user.user_address.includes(:user,:region, :province, :city, :barangay)
  end

  def new
    @user_address = UserAddress.new
  end

  def create
    @user_address = UserAddress.new(address_params)
    @user_address.user = current_user
    if @user_address.save
      flash[:notice] = 'Address added successfully'
      redirect_to client_user_addresses_path
    else
      flash.now[:alert] = 'Address added failed'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update

    if @user_address.update(address_params)
      flash[:notice] = 'Address updated successfully'
      redirect_to client_user_addresses_path
    else
      flash.now[:alert] = 'Address update failed'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user_address.destroy
    flash[:notice] = 'Address deleted successfully'
    redirect_to client_user_addresses_path
  end

  private

  def set_address
    @user_address = UserAddress.find(params[:id])
  end

  def address_params
    params.require(:user_address).permit(:genre, :name, :street, :phone, :remark, :address_region_id, :address_province_id, :address_city_id, :address_barangay_id)
  end
end
