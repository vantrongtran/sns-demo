class Aws::Sns::PushService
  def initialize
    @sns_client = Aws::SNS::Client.new
  end

  def push sns_message, device_token
    @sns_client.publish(
      target_arn: endpoint_arn(device_token, sns_message.type),
      message: sns_message.to_json,
      message_structure: :json
    )

  rescue Aws::SNS::Errors::ServiceError => e
    binding.pry
    Logger.new(Rails.root.join("log", "notification_push.log")).warn e.message
  end

  private

  def endpoint_arn device_token, type
    @sns_client.create_platform_endpoint(
      platform_application_arn: Rails.application.credentials.dig(:aws, "#{type}_arn".to_sym),
      token: device_token
    ).endpoint_arn
  end
end
