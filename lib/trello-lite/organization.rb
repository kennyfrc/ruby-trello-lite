module Trello
  class Organization
    attr_accessor :attributes

    def initialize(attrs = {})
      @attributes = attrs
      @boards = []
    end

    def display_name
      attributes[:displayName]
    end

    def name
      attributes[:displayName]
    end

    def boards(limit = "all")
      attributes[:idBoards].each_with_index do |board_id, idx|
        @boards << Board.new(board_id)
        unless limit == "all"
          break if (idx + 1) == limit
        end
      end
      @boards
    end
  end
end