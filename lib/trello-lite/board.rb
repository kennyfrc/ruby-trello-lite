module Trello
  class Board
    attr_accessor :id, :lists, :attributes

    def initialize(id, attrs = {})
      @id = id
      @lists = []
      @attributes = attrs
      find(id)
    end

    def credentials
      Trello.credentials
    end

    def find(id)
      board_url = "https://api.trello.com/1/boards/#{id}?fields=all&#{credentials}"
      board_list_url = "https://api.trello.com/1/boards/#{id}/lists?cards=open&card_fields=name&filter=open&fields=all&#{credentials}"
      @attributes = Trello.parse(board_url)
      Trello.parse(board_list_url).each do |list_json|
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