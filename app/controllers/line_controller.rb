class LineController < ApplicationController
  protect_from_forgery with: :null_session

  # def call(env)
  #   byebug
  #   req = make_request(env)
  #   req.path_info = Journey::Router::Utils.normalize_path(req.path_info)
  #   @router.serve(req)
  #     params     = req.path_parameters
  #     controller = req.controller_class
  #     res        = controller.make_response! req
  #     controller.dispatch(params[:action], req, res)
  # end

  # {
  #   "action_dispatch.request.path_parameters":{:controller=>"line", :action=>"test"}
  # }

  def env
    # GATEWAY_INTERFACE
    # HTTP_ACCEPT
    # HTTP_ACCEPT_ENCODING
    # HTTP_ACCEPT_LANGUAGE
    # HTTP_ALEXATOOLBAR_ALX_NS_PH
    # HTTP_CACHE_CONTROL
    # HTTP_CONNECTION
    # HTTP_COOKIE
    # HTTP_HOST
    # HTTP_UPGRADE_INSECURE_REQUESTS
    # HTTP_USER_AGENT
    # HTTP_VERSION
    # ORIGINAL_FULLPATH
    # ORIGINAL_SCRIPT_NAME
    # PATH_INFO
    # QUERY_STRING
    # REMOTE_ADDR
    # REQUEST_METHOD
    # REQUEST_PATH
    # REQUEST_URI
    # ROUTES_70201236780880_SCRIPT_NAME
    # SCRIPT_NAME
    # SERVER_NAME
    # SERVER_PORT
    # SERVER_PROTOCOL
    # SERVER_SOFTWARE
    # action_dispatch.authenticated_encrypted_cookie_salt
    # action_dispatch.backtrace_cleaner
    # action_dispatch.content_security_policy
    # action_dispatch.content_security_policy_nonce_generator
    # action_dispatch.content_security_policy_report_only
    # action_dispatch.cookies_digest
    # action_dispatch.cookies_rotations
    # action_dispatch.cookies_serializer
    # action_dispatch.encrypted_cookie_cipher
    # action_dispatch.encrypted_cookie_salt
    # action_dispatch.encrypted_signed_cookie_salt
    # action_dispatch.http_auth_salt
    # action_dispatch.key_generator
    # action_dispatch.logger
    # action_dispatch.parameter_filter
    # action_dispatch.redirect_filter
    # action_dispatch.remote_ip
    # action_dispatch.request_id
    # action_dispatch.routes
    # action_dispatch.secret_key_base
    # action_dispatch.secret_token
    # action_dispatch.show_detailed_exceptions
    # action_dispatch.show_exceptions
    # action_dispatch.signed_cookie_digest
    # action_dispatch.signed_cookie_salt
    # action_dispatch.use_authenticated_cookie_encryption
    # puma.config
    # puma.socket
    # rack.after_reply
    # rack.errors
    # rack.hijack
    # rack.hijack?
    # rack.input
    # rack.multiprocess
    # rack.multithread
    # rack.run_once
    # rack.session
    # rack.session.options
    # rack.tempfiles
    # rack.url_scheme
    # rack.version
  end

  def p1
    {
      "action_dispatch.request.path_parameters" => {
        controller: "line",
        action: "test"
      }
    }
  end

  def test
    request.path_info = "#{todo_index_path}.line"
    request.request_method = "GET"
    res = Rails.application.routes.router.serve(request)
    res_body = res[2].body
    head :ok
  end

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
    response = client.reply_message(reply_token, output)
  end

  def reserve_route_for_line(path, method)
    request.path_info = "#{path}.line"
    request.request_method = method
    res = Rails.application.routes.router.serve(request)
    res_body = res[2].body
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
