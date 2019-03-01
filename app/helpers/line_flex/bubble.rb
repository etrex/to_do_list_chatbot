module LineFlex
  class Bubble
    include Container
    include Actions

    def initialize
      @alt_text = "this is a flex message"
      @hero = nil
      @header = nil
      @body = nil
      @footer = nil
    end

    def hero(**params)
      @hero = image(**params)
    end

    def header(**params, &block)
      @header = box(**params, &block)
    end

    def body(**params, &block)
      @body = box(**params, &block)
    end

    def footer(**params, &block)
      @footer = box(**params, &block)
    end

    def to_h
      {
        type: "flex",
        altText: @alt_text,
        contents: contents,
        quickReply: @quick_reply&.to_h,
      }.compact
    end

    def to_json
      JSON.pretty_generate(to_h)
    end

    def quick_reply(&block)
      @quick_reply = QuickReply.new
      @quick_reply.instance_exec(&block)
    end
    private

    def contents
      {
        type: "bubble",
        header: @header&.to_h,
        hero: @hero&.to_h,
        body: @body&.to_h,
        footer: @footer&.to_h,
      }.compact
    end
  end
end