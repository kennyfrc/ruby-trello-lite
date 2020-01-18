module Trello
 class Client
    def configure(&block)
      return puts "No configuration details passed" unless block_given?
      yield configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def credentials
      "key=#{configuration.consumer_key}&token=#{configuration.oauth_token}"
    end
  end
end