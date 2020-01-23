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
  puts "checking org #{org.name}"
  org.boards.each do |board|
    puts "chekcing board #{board.name}"
    board.custom_fields.each do |custom_field|
      puts "deleting #{custom_field.name}"
      custom_field.delete
    end

    puts "creating fields"
    if !board.has_custom_fields?
      puts "adding the powerup"
      board.enable_custom_fields
    end
    puts "adding the field finally"
    board.create_work_units_field
  end
end

kenn.get_orgs_by_name("MGV Operations").each do |org| 
  org.boards.each do |board|
    puts board.custom_fields
  end
end
