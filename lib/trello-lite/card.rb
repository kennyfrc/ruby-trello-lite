module Trello
  class Card
    attr_accessor :attributes, :url, :activities, :activities_url

    def initialize(attrs = {})
      @attributes = attrs
      @url = "https://api.trello.com/1/cards/#{attributes[:id]}?fields=all&members=true&member_fields=fullName%2Cusername&#{Trello.credentials}"
      @activities_url = "https://api.trello.com/1/cards/#{attributes[:id]}/actions?limit=5&#{Trello.credentials}"
      @card_json = nil
      @activities = []
      @members = []
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

    def members
      card_json[:members].each do |member|
        @members << Member.new(member)
      end
      @members
    end

    def status
      unless due_complete
        days = Date.parse(Time.now.strftime('%d/%m/%Y')) - Date.parse(due)
        "Delayed by #{days.to_i} days"
      else
        "Done"
      end
    end

    def activities_url
      @activities_url
    end

    def activities(limit = 5)
      unless @activities.empty? || limit != 5
        @activities
      else
        Trello.parse(activities_url).each_with_index do |activity, idx|
          _activity = Activity.new(activity)
          if _activity.type == "updateCard" && !_activity.old_list.nil?
            @activities << _activity
          end
          break if @activities.size == limit
        end
      end
    end
  end
end