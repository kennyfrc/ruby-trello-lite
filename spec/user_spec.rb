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

    # this will stop working if there's no card in the live boards that > 5 days old
    # it "can get created cards from X" do
    #   expect(board.check_created_cards_since(5.days.ago).class).to eq Array
    #   expect(board.check_created_cards_since(5.days.ago)[0].class).to eq Trello::Activity
    #   expect(board.check_created_cards_since(5.days.ago)[0].name).to eq "something"
    #   expect(board.check_created_cards_since(5.days.ago)[0].short_link).to eq "https://trello.com/c/UPd7RKD4"
    #   expect(board.check_created_cards_since(5.days.ago)[0].updated_at).to eq "19/01/2020"
    # end

    ## Get members' cards for a board | https://developers.trello.com/reference#membersidboards

    it "can get members' cards in a board" do
      expect(board.find_list("Moving Out").cards_by_member("kennyfrc").class).to eq Array
      expect(board.find_list("Moving Out").cards_by_member("kennyfrc")[0].class).to eq Trello::Card
      expect(board.find_list("Moving Out").cards_by_member("kennyfrc")[0].name).to eq "MIDDLE cabinet - buy cr2032 batter for garmin awatch"
    end
  end

  describe "List" do
    let(:list) {
      board.find_list("Moving Out")
    }

    it "get the list based on a name" do
      expect(list.name).to eq "Moving Out"
      expect(list.class).to eq Trello::List
    end

    it "get card name of a named list" do
      expect(list.cards[0].name).to eq "MIDDLE cabinet - buy cr2032 batter for garmin awatch"
    end
  end

  describe "Card" do
    let(:list) {
      board.find_list("Moving Out")
    }
    
    let(:card) {
      list.find_card("MIDDLE cabinet - buy cr2032 batter for garmin awatch")
    }

    it "can find a card based on the name" do
      expect(card.name).to eq "MIDDLE cabinet - buy cr2032 batter for garmin awatch"
    end

    it "has a due date" do
      expect(card.due).to eq "17/08/2015"
    end

    it "has a last activity" do
      expect(card.last_activity).to eq "19/01/2020"
    end

    it "has a due complete" do
      expect(card.due_complete).to eq false
    end

    it "contains a short url" do
      expect(card.short_link).to eq "https://trello.com/c/NLHqoq08"
    end

    it "days ahead or before due" do
      expect(card.status).to eq "Delayed by #{(Date.parse(Time.now.strftime('%d/%m/%Y')) - Date.parse("17/08/2015")).to_i} days"
    end

    it "has activities" do
      expect(card.activities.class).to eq Array
      expect(card.activities[0].class).to eq Trello::Activity
      expect(card.activities[0].type).to eq "updateCard"
      expect(card.activities[0].old_list).to eq "miCab MKT & partnerships"
      expect(card.activities[0].new_list).to eq "Moving Out"
      expect(card.activities[0].updated_at).to eq "18/01/2020"
    end

    it "has members" do
      expect(card.members.class).to eq Array
      expect(card.members[0].class).to eq Trello::Member
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
## DONE - card changes only - check activities | https://developers.trello.com/reference#cardsidactions
## DONE check if the task was moved to another list
## DONE get members in a card
## DONE LIST | check if we have any tasks created this week | https://developers.trello.com/reference#listsidactions
## DONE LIST? | check the create date of the card | https://developers.trello.com/reference#listsidactions
## DONE Get members' cards for a board | https://developers.trello.com/reference#membersidboards
## DONE Get members' cards for a board and a specific list | https://developers.trello.com/reference#membersidcards
## Post work units for a card
## Get work units for a card

# check rate limit
## 300 requests per 10 seconds


