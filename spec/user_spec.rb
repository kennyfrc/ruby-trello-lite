require_relative 'spec_helper'
require 'dotenv/load'
require './lib/trello'

Trello.configure do |config|
  config.consumer_key = ENV['CONSUMER_KEY']
  config.oauth_token = ENV['OAUTH_TOKEN']
end

describe "Member" do
  let(:kenn) {
    Trello::Member.find("kennyfrc")
  }

  let(:board) {
    kenn.find_board("okrs")
  }

  let(:lists) {
    board.lists
  }

  let(:list) {
    board.find_list("Moving Out")
  }

  let(:cards) {
    lists.first.cards
  }

  let(:card) {
    list.find_card("MIDDLE cabinet - buy cr2032 batter for garmin awatch")
  }

  describe "has properties such as" do
    it "can return the full name" do
      expect(kenn.full_name).to eq "Kenn Costales"
    end

    it "can return the bio" do
      expect(kenn.bio).to eq "Managing Director of Monolith Growth Consulting / [monolithgrowth.com](https://monolithgrowth.com)"
    end

    it "can return an array of boards" do
      expect(kenn.boards(1).class).to eq Array
      expect(kenn.boards(1)[0].class).to eq Trello::Board
    end
  end

  describe "Board" do
    it "can get the board name" do
      expect(board.name).to eq "OKRs"
    end

    it "can get the lists of a board" do
      expect(board.lists.class).to eq Array
      expect(board.lists[0].class).to eq Trello::List
      expect(board.lists[0].name.class).to eq String
    end
  end

  describe "List" do
    it "get the list based on a name" do
      expect(list.name).to eq "Moving Out"
      expect(list.class).to eq Trello::List
    end

    it "get card name of a named list" do
      expect(list.cards.class).to eq Array
      expect(list.cards[0].name).to eq "MIDDLE cabinet - buy cr2032 batter for garmin awatch"
    end
  end

  describe "Card" do
    it "can find a card based on the name" do
      expect(card.name).to eq "MIDDLE cabinet - buy cr2032 batter for garmin awatch"
    end

    it "has a due date" do
      expect(card.due).to eq "08/17/15"
    end

    it "has a last activity" do
      expect(card.last_activity).to eq "16/01/20"
    end

    it "has a due complete" do
      expect(card.due_complete).to eq false
    end

    it "contains a short url" do
      expect(card.short_link).to eq "https://trello.com/c/NLHqoq08"
    end

    it "days ahead or before due" do
      expect(card.status).to eq "Delayed by 884 days"
    end
  end
end


# megatracker features
## DONE get cards from the "Backlog", "Doing", "Done", "Sprint" cards
## DONE what card names are in the list
## DONE check if the task has been made
## DONE are we on or off the due date
## DONE check the date of last activity of that card
## DONE when is the due date of the card
## check activities | https://developers.trello.com/reference#cardsidactions
## check if the task was moved to another list
## LIST | check if we have any tasks created this week | https://developers.trello.com/reference#listsidactions
## LIST? | check the create date of the card | https://developers.trello.com/reference#listsidactions

# check rate limit
## 300 requests per 10 seconds


