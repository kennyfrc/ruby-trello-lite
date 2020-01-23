require 'dotenv/load'
require './lib/trello'

# load configuration variables
# what this does is that it TAKES an object "config", then it assigns
# vaues to the instance variables of that "config" object
Trello.configure do |config|
  config.consumer_key = ENV['CONSUMER_KEY']
  config.oauth_token = ENV['OAUTH_TOKEN']
end

# get member object for kennyfrc
kenn = Trello::Member.find("kennyfrc")

kenn.get_orgs_by_name("MGV Operations").each do |org| 
  org.boards.each do |board|
    board.custom_fields.each do |custom_field|
      custom_field.delete
    end

    board.create_work_units_field
  end
end
