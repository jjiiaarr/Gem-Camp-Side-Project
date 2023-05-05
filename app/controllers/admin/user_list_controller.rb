class Admin::UserListController < ApplicationController
  # before_action :authenticate_user!

  def index
    @users = User.client
  end
end
