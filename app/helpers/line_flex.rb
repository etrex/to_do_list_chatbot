
module LineFlex
  # 設定規則
  def self.bubble(&block)
    bubble = Bubble.new
    bubble.instance_exec(&block)
    bubble
  end
end