module Trello
  class CustomField
    attr_accessor :attributes

    def initialize(attrs = {})
      @attributes = attrs
    end
  end
end