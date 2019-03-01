module LineFlex
  class QuickReply
    include Actions

    def initialize
      @items = []
    end

    def to_h
      return nil if @items.empty?
      {
        "items": @items.map {|item|
          {
            "type": "action",
            "action": item
          }
        }
      }
    end
  end
end