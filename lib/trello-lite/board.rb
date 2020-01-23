module Trello
  class Board
    attr_accessor :id, :lists, :attributes

    def initialize(id, attrs = {})
      @id = id
      @lists = []
      @attributes = attrs
      @board_url = "https://api.trello.com/1/boards/#{id}?fields=all&members=all"
      @board_list_url = "https://api.trello.com/1/boards/#{id}/lists?cards=open&card_fields=name&filter=open&fields=all"
      @members = []
      find(id)
    end

    def credentials
      Trello.credentials
    end

    def find(id)
      @attributes = Trello.parse(@board_url + "&#{credentials}")
      attributes[:members].each do |member|
        member_obj = Member.new(member)
        @members << member_obj
      end
      Trello.parse(@board_list_url + "&#{credentials}").each do |list_json|
        list = List.new(list_json)
        @lists << list
      end
      self
    end

    def find_list(name)
      list_obj = nil
      lists.each do |list|
        list_obj = list if list.name == name
      end
      if list_obj.nil?
        puts "List doesn't exist. Here are some list names."
        lists.each do |list|
          puts list.name
        end
      else
        list_obj
      end
    end

    def find_member(name)
      @members.each do |member|
        if name == member.full_name || name == member.username
          return member
        end
      end
    end

    def check_created_cards_since(days_ago)
      url = "https://api.trello.com/1/boards/#{id}/actions?#{credentials}"
      activities = Trello.parse(url)
      created_cards = []
      activities.each do |activity|
        if activity[:type] == "createCard" && Time.parse(activity[:date]) > days_ago
          created_cards << Activity.new(activity)
        end
      end
      created_cards
    end

    def lists
      @lists
    end

    def name
      attributes[:name]
    end

    def desc
      attributes[:desc]
    end

    def url
      attributes[:url]
    end
  end
end