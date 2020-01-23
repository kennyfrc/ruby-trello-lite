module Trello
  class CustomField
    attr_accessor :attributes

    def initialize(attrs = {})
      @attributes = attrs
    end

    def id
      attributes[:id]
    end

    def type
      attributes[:type]
    end

    def name
      attributes[:name]
    end

    def delete
      url = "https://api.trello.com/1/customfields/#{id}?" + Trello.credentials
      response = HTTParty.delete(url, format: :plain)
      JSON.parse(response, symbolize_names: true)
    end
  end
end