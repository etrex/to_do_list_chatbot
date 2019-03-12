module LineFlex
  class Box
    include Container
    include Actions
    include LiffHelper

    def initialize(params)
      @params = {layout: "vertical"}.merge(params)
      @contents = []
    end

    def to_h
      return nil if @contents.empty?
      {
        type: "box",
        contents: @contents.map(&:to_h)
      }.merge(@params)
    end

    def text(message, **params)
      @contents << {
        "type": "text",
        "text": message
      }.merge(params)
    end

    def separator(**params)
      @contents << {
        "type": "separator",
        "margin": "md",
        "color": "#000000",
      }.merge(params)
    end

    def spacer(**params)
      @contents << {
        "type": "spacer",
        "size": "md",
      }.merge(params)
    end
  end
end