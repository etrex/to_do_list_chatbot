
class LiffController < ApplicationController
  include ReverseRoute
  layout "liff"

  def entry
    query = Rack::Utils.parse_nested_query(request.query_string)
    @title = query["title"]
    @body = reserve_route(query["path"], format: :liff)
  end
end
