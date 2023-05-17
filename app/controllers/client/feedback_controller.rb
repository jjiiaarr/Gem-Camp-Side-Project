class Client::FeedbackController < ApplicationController

  def show
    @winner = Winner.includes(:user_address, :item, :bet).where(user: current_user).find(params[:id])
    @user_address = UserAddress.where(user: current_user)
  end

  def update
    @winner = Winner.where(user: current_user).find(params[:id])

    if @winner.update(feedback_params)
      @winner.share! if @winner.may_share?
      @winner.save
      flash[:notice] = "Feedback was successfully submitted"
      redirect_to client_profile_path(winner: :winners)
    else
      flash[:alert] = @winner.errors.full_messages.join(", ")
      redirect_to client_feedback_path
    end
  end

  private

  def feedback_params
    params.require(:winner).permit(:picture, :comment)
  end
end
