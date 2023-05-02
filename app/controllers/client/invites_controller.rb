class Client::InvitesController < ApplicationController
  before_action :generate_qr
  before_action :invite_link

  require "rqrcode"

  def index; end

  private

  def invite_link

    if current_user
      @url = "client.com:3000/users/sign_up?promoter=#{current_user.email}"
    else
      @url = "client.com:3000/users/sign_up"
    end

  end

  def generate_qr

    qr = RQRCode::QRCode.new("#{invite_link}")
    # NOTE: showing with default options specified explicitly
    @svg = qr.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 11,
      standalone: true,
      use_path: true
    )
  end
end

