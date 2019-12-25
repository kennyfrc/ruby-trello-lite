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

# return member's full name
puts kenn.full_name

# return member's bio
puts kenn.bio

# boards
puts kenn.boards