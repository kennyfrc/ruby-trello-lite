module Trello
  class List
    attr_accessor :attributes

    def initialize(attrs = {})
      @attributes = attrs
      @cards = []
      @attributes[:cards].each do |card|
        card_obj = Card.new(card)
        @cards << card_obj
      end
    end

    def id
      attributes[:id]
    end

    def name
      attributes[:name]
    end

    def cards
      @cards
    end

    def find_card(name = "")
      card_obj = nil
      cards.each do |card|
        card_obj = card if card.name == name
      end
      if card_obj.nil?
        puts "Card doesn't exist. Here are some card names."
        cards.each do |card|
          puts card.name
        end
      else
        card_obj
      end
    end
  end
end