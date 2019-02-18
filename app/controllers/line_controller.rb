class LineController < ApplicationController
  protect_from_forgery with: :null_session

  def entry
    body = request.body.read
    events = client.parse_events_from(body)
    events.each do |event|
      process_event(event)
    end
    head :ok
  end

  private

  def process_event(event)
    reply_token = event['replyToken']
    input = event.message['text']
    output = reserve_route_for_line(input, "GET")
    response = client.reply_message(reply_token, JSON.parse(output))
  rescue
    response = client.reply_message(reply_token, {
      type: "text",
      text: "404 not found"
    })
  end

  def reserve_route_for_line(path, method)
    request.path_info = path
    request.request_method = method
    request.format = :line
    res = Rails.application.routes.router.serve(request)
    res[2].body
  end

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
