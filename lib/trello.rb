require 'httparty'
require 'pry-byebug'

module Trello
  # parse url using httparty and return json
  def self.parse(url)
    response = HTTParty.get(url, format: :plain)
    JSON.parse(response, symbolize_names: true)
  end

  # set up configuration
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

 class Client
    def configure(&block)
      return puts "No configuration details passed" unless block_given?
      yield configuration
      puts "Configuration worked!"
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def credentials
      "key=#{configuration.consumer_key}&token=#{configuration.oauth_token}"
    end
  end

  # initialize a client in the environment
  def self.client
    @client ||= Client.new
  end

  # block for taking in some credentials
  def self.configure(&block)
    client.configure(&block)
  end

  # class methods in the Client object access the environment
  # instance methods do the actual work
  def self.credentials
    client.credentials
  end

  class Member
    attr_accessor :attributes

    # to keep things pragmatic, @attributes holds the json
    # a cool feature in the future is to use metaprogramming to automatically
    # create instance methods, including an #instance_methods method
    # to help the user better understand the API.
    def initialize(attrs = {})
      @attributes = attrs
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
      @username
    end

    # just returns an array for now - would be cool to use activemodel
    def boards(number = "none")
      board_objects = []
      attributes[:idBoards].each_with_index do |id_board, idx|
        number == "none" ? number = attributes[:idBoards].size : number
        board_number = idx + 1
        puts "Loading board #{board_number} of #{number} | Total is #{attributes[:idBoards].size}"
        board_objects << Board.new(id_board)
        break if board_number == number
      end
      board_objects
    end

    def find_board(name)
      board = nil
      attributes[:idBoards].each_with_index do |id_board, idx|
        board_number = idx + 1
        puts "Checking #{board_number} of #{attributes[:idBoards].size}"
        Board.new(id_board).name.downcase.include?(name.downcase) ? board = Board.new(id_board) : next
        break
      end
      board
    end
  end

  # initialize a member in the environment
  def self.member
    @member ||= Member.new
  end

  # class methods in the Member object access the environment
  # instance methods do the actual work
  def self.find_member(username)
    member.find(username)
  end

  class Board
    attr_accessor :id, :lists

    def initialize(id, attrs = {})
      @id = id
      @lists = []
      find(id)
    end

    def credentials
      Trello.credentials
    end

    def find(id)
      board_url = "https://api.trello.com/1/boards/#{id}?fields=all&#{credentials}"
      board_list_url = "https://api.trello.com/1/boards/#{id}/lists?cards=open&card_fields=name&filter=open&fields=name&#{credentials}"
      @attributes = Trello.parse(board_url)
      Trello.parse(board_list_url).each do |list_json|
        list = List.new(list_json)
        @lists << list
      end
    end

    def name
      @attributes[:name]
    end

    def desc
      @attributes[:desc]
    end

    def url
      @attributes[:url]
    end
  end

  class List
    def initialize(attrs = {})
      @attributes = attrs
      @cards = []
      @attributes[:cards].each do |card|
        card_obj = Card.new(card)
        @cards << card_obj
      end
    end

    def id
      @attributes[:id]
    end

    def name
      @attributes[:name]
    end

    def cards
      @cards
    end
  end

  class Card
    def initialize(attrs = {})
      @attributes = attrs
    end

    def id
      @attributes[:id]
    end

    def name
      @attributes[:name]
    end
  end
end