require 'httparty'
require 'pry-byebug'
require 'active_support/core_ext/integer/time'

module Trello
  autoload :Card,                   'trello-lite/card'
  autoload :List,                   'trello-lite/list'
  autoload :Board,                  'trello-lite/board'
  autoload :Client,                 'trello-lite/client'
  autoload :Member,                 'trello-lite/member'
  autoload :Activity,               'trello-lite/activity'
  autoload :Configuration,          'trello-lite/configuration'

  # parse url using httparty and return json
  def self.parse(url)
    response = HTTParty.get(url, format: :plain)
    JSON.parse(response, symbolize_names: true)
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

  # initialize a member in the environment
  def self.member
    @member ||= Member.new
  end

  # class methods in the Member object access the environment
  # instance methods do the actual work
  def self.find_member(username)
    member.find(username)
  end
end