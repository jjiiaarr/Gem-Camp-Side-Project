class Client::ClaimController < ApplicationController

  def show
    @winner = Winner.includes(:user_address, :item, :bet).where(user: current_user).find(params[:id])
    @user_address = UserAddress.where(user: current_user)
  end

  def update
    @winner = Winner.where(user: current_user).find(params[:id])

    if @winner.update(user_address_params)
      if @winner.may_claim?
        @winner.claim!
      else
        flash[:alert] = "Prize cannot be claimed"
      end
      @winner.save
      flash[:notice] = "Prize Claim was successfully updated"
      redirect_to client_profile_path(winner: :winners)
    else
      flash[:alert] = @winner.errors.full_messages.join(", ")
      redirect_to client_claim_path
    end
  end

  private

  def user_address_params
    params.require(:winner).permit(:user_address_id)
  end
end
