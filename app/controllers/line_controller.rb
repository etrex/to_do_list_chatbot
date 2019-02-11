class LineController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    body = request.body.read
    events = client.parse_events_from(body)
    events.each do |event|
      reply_token = event['replyToken']
      message = {
        type: 'text',
        text: 'QQ'
      }
      response = client.reply_message(reply_token, message)
      p response.body
    end
    head :ok
  end

  private

  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    end
  end

  def validate_signature(request, body)
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    client.validate_signature(body, signature)
  end
end
