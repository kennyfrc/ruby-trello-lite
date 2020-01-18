module Trello
  class Card
    attr_accessor :attributes, :url

    def initialize(attrs = {})
      @attributes = attrs
      @url = "https://api.trello.com/1/cards/#{attributes[:id]}?fields=all&#{Trello.credentials}"
      @card_json = nil
    end

    def id
      attributes[:id]
    end

    def name
      attributes[:name]
    end

    def due
      Time.parse(card_json[:due]).strftime("%d/%m/%y")
    end

    def card_json
      @card_json ||= Trello.parse(url)
    end

    def last_activity
      Time.parse(card_json[:dateLastActivity]).strftime("%d/%m/%y")
    end

    def due_complete
      card_json[:dueComplete]
    end

    def short_link
      card_json[:shortUrl]
    end

    def status
      unless due_complete
        days = Date.parse(Time.now.strftime('%d/%m/%Y')) - Date.parse(due)
        "Delayed by #{days.to_i} days"
      else
        "Done"
      end
    end
  end
end