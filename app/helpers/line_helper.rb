module LineHelper
  def flex_list_view(title: "title", menu_action: nil, new_action: nil, list: [], empty_message: "no data")
    flex_bubble(
      body: flex_vertical_box([
        flex_nav(title: title, menu_action: menu_action, new_action: new_action),
        flex_separator,
        flex_list_body(list, margin: "lg") || flex_empty_body(empty_message, margin: "lg"),
      ])
    )
  end

  private

  def flex_list_body(list, **params)
    return nil if list.empty?
    list = list.map do |data|
      action = flex_message_action("/#{data.class.to_s.downcase.pluralize}/#{data.id}")
      flex_horizontal_box([flex_text(data.name)], action: action)
    end
    flex_vertical_box([list], **params)
  end

  def flex_empty_body(text, **params)
    flex_text(text, **params)
  end

  def flex_nav(title:, menu_action: nil, new_action: nil)
    flex_vertical_box([
      flex_horizontal_box([
        flex_text("三", flex: 0, action: menu_action),
        flex_text(title, margin: "md"),
        flex_text("+", align: "end", action: new_action),
      ])
    ])
  end

  # basic function
  def flex_bubble(text: "this is a flex message", body:)
    {
      "type": "flex",
      "altText": text,
      "contents": {
        "type": "bubble",
        "body": body
      }
    }
  end

  def flex_box(contents, **params)
    raise "Contents should be an array." unless contents&.is_a? Array
    {
      "type": "box",
      "contents": contents.flatten
    }.merge(params)
  end

  def flex_vertical_box(contents, **params)
    flex_box(contents, layout: "vertical", **params)
  end

  def flex_horizontal_box(contents, **params)
    flex_box(contents, layout: "horizontal", **params)
  end

  def flex_text(text, **params)
    {
      "type": "text",
      "text": text
    }.merge(params)
  end

  def flex_separator(margin: "md", color: "#000000")
    {
      "type": "separator",
      "margin": margin,
      "color": color,
    }
  end

  def flex_spacer(margin: "md")
    {
      "type": "spacer",
      "size": "md",
    }
  end

  def flex_message_action(text, **params)
    {
      "type": "message",
      "text": text
    }.merge(params)
  end
end
