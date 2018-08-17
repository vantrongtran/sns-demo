class PagesController < ApplicationController
  def index
  end

  def create
    Aws::Sns::PushService.new.push message(params[:push_text], params[:device_type]), device_token(params[:device_type])
    render :index
  end

  private

  def message title, device_type
    Aws::Sns::Message.build do |msg|
      msg.content = title
      msg.type = device_type
    end
  end

  def device_token device_type
    device_type == "ios" ? "99c14bc16dccbfae9427dc54b86ca798c69227b94b87fa29bb0e9a2cf8071561" : ""
  end
end
