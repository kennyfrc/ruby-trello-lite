module Trello
  class Activity
    attr_accessor :attributes

    def initialize(attrs = {})
      @attributes = attrs
    end

    def type
      attributes[:type]
    end

    def old_list
      unless attributes[:data][:listBefore].nil?
        attributes[:data][:listBefore][:name]
      else
        nil
      end
    end

    def new_list
      unless attributes[:data][:listAfter].nil?
        attributes[:data][:listAfter][:name]
      else
        nil
      end
    end

    def updated_at
      Date.parse(attributes[:date]).strftime('%d/%m/%Y')
    end
  end
end