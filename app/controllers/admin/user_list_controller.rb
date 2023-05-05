class Admin::UserListController < ApplicationController
  layout 'admin'
  # before_action :authenticate_user!

  def index
    @users = User.client
  end
end
