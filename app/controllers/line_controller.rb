class LineController < ApplicationController
  include ReverseRoute
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
    event
    http_method, path, request_params = language_understanding(event.message['text'])
    output = reserve_route(path, http_method: http_method, request_params: request_params, format: :line)
    response = client.reply_message(reply_token, JSON.parse(output))
    puts response.body

  rescue NoMethodError => e
    puts e.message
    response = client.reply_message(reply_token, {
      type: "text",
      text: "404 not found"
    })
  end

  def language_understanding(text)
    http_method = %w[GET POST PUT PATCH DELETE].find do |http_method|
      text.start_with? http_method
    end
    text = text[http_method.size..-1] if http_method.present?
    text = text.strip
    lines = text.split("\n").compact
    path = lines.shift
    request_params = parse_json(lines.join(""))
    request_params[:authenticity_token] = form_authenticity_token
    http_method = request_params["_method"]&.upcase || http_method || "GET"
    [http_method, path, request_params]
  end

  def parse_json(string)
    return {} if string.strip.empty?
    JSON.parse(string)
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
