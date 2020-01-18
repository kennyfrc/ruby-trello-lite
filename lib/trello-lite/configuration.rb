module Trello
  class Configuration
    CONFIG_ATTRIBUTES = [
      :consumer_key,
      :consumer_secret,
      :oauth_token,
      :oauth_token_secret
    ]

    attr_accessor *CONFIG_ATTRIBUTES

    def initialize(attrs = {})
      @attributes = attrs
    end

    # this only works if you pass values through a block
    def attributes=(attrs = {})
      attrs.each { |key, value| instance_variable_set("@#{key}", value) }
    end
  end
end