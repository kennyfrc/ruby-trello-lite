module Trello
  class Member
    attr_accessor :attributes

    # to keep things pragmatic, @attributes holds the json
    # a cool feature in the future is to use metaprogramming to automatically
    # create instance methods, including an #instance_methods method
    # to help the user better understand the API.
    def initialize(attrs = {})
      @attributes = attrs
      @boards = []
    end

    def credentials
      Trello.credentials
    end

    def self.find(username)
      @username = username
      Trello.find_member(username)
    end

    def find(username)
      url = "https://api.trello.com/1/members/#{username}?fields=all&#{credentials}"
      @attributes = Trello.parse(url)
      self
    end

    def full_name
      attributes[:fullName]
    end

    def bio
      attributes[:bio]
    end

    def username
      @username ||= attributes[:username]
    end

    # just returns an array for now - would be cool to use activemodel
    def boards(number = "none")
      attributes[:idBoards].each_with_index do |id_board, idx|
        number == "none" ? number = attributes[:idBoards].size : number
        board_number = idx + 1
        @boards << Board.new(id_board)
        break if board_number == number
      end
      @boards
    end

    def find_board(name)
      board = nil
      attributes[:idBoards].each_with_index do |id_board, idx|
        board_number = idx + 1
        Board.new(id_board).name.downcase.include?(name.downcase) ? board = Board.new(id_board) : next
        break
      end
      board
    end
  end
end