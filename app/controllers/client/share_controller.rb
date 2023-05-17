class Client::ShareController < ApplicationController
  def index
    @winners = Winner.where(state: :published)
  end
end
