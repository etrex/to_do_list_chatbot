module LineFlex
  module Container
    def box(**params, &block)
      box = Box.new(params)
      box.instance_exec(&block)
      box
    end

    def vertical_box(**params, &block)
      @contents << box(**params, &block)
    end

    def horizontal_box(**params, &block)
      @contents << box(layout: "horizontal", **params, &block)
    end

    def nav(title, menu_action: nil, new_action: nil)
      horizontal_box do
        text "三", flex: 0, action: menu_action
        text title
        text "+", align: "end", action: new_action
      end
    end

    def list(resources, **params, &block)
      return nil if resources.nil?
      vertical_box **params do
        resources.each do |resource|
          self.instance_exec(resource, &block)
        end
      end
    end
  end
end