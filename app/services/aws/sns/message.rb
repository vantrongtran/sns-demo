class Aws::Sns::Message
  attr_accessor :content, :type, :sound, :id

  def to_json
    case type
    when "ios"
      {
        APNS:  ios_payload.to_json,
        APNS_SANDBOX: ios_payload.to_json
      }
    else
      {
        GCM: android_payload.to_json
      }
    end.to_json
  end

  private

  def ios_payload
    {
      aps: {
        alert: content,
        sound: sound || "default"
      }
    }
  end

  def android_payload
    {
      data: {
        message: notification.title
      }
    }
  end

  class << self
    def build
      builder = new
      yield builder
      builder
    end
  end
end
