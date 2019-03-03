module LineFlex
  module Actions
    # Postback Action
    def postback_aciton(label, **params)
      action = {
        type: "postback",
        label: label,
        data: label,
        text: label
      }.merge(params)
      @items << action unless @items.nil?
      action
    end

    # Message Action
    def message_action(label, **params)
      action = {
        type: "message",
        label: label,
        text: label
      }.merge(params)
      @items << action unless @items.nil?
      action
    end

    # URI
    def uri_action(uri, **params)
      action = {
        type: "uri",
        label: uri[0...40],
        uri: uri,
        # altUri: {
        #   desktop: uri
        # }
      }
      @items << action unless @items.nil?
      action
    end

    # Datetime picker action
    def datetime_picker_action(label, **params)
      action = {
        type: "datetimepicker",
        mode: "datetime",
        label: label,
        data: label
      }.merge(params)
      @items << action unless @items.nil?
      action
    end

    def date_picker_action(label, **params)
      datetime_picker_action(label, mode: "date", **params)
    end

    def time_picker_action(label, **params)
      datetime_picker_action(label, mode: "time", **params)
    end

    # Camera action
    def camera_action(label)
      action = {
        type: "camera",
        label: label
      }
      @items << action unless @items.nil?
      action
    end

    # Camera roll action
    def camera_roll_action(label)
      action = {
        type: "cameraRoll",
        label: label
      }
      @items << action unless @items.nil?
      action
    end

    # Location action
    def location_action(label)
      action = {
        type: "location",
        label: label
      }
      @items << action unless @items.nil?
      action
    end
  end
end
