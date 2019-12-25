require 'httparty'
require 'pry-byebug'

=begin
# What you learned so far:
	* How configuration through a block works (search for Trello.configure)
	* How you can get standard libraries to work in local 
		(especially when autoload is used) ($LOAD_PATH.unshift 'lib'). This is true
		in the case where you use the original library
	* Metaprogramming hacks
		* What I've noticed is that it's mainly a tool to add instance variables,
			methods, and classes after it has been defined. It reminds me of 
			the way you can set methods in javascript after an object has been defined.
=end

module Trello
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
			self.attributes = attrs
		end

    def attributes=(attrs = {})
      attrs.each { |key, value| instance_variable_set("@#{key}", value) }
    end
	end

	# block for taking in some credentials
	def self.configure(&block)
		member.configure(&block)
	end

	# parse url using httparty and return json
	def self.parse(url)
		response = HTTParty.get(url, format: :plain)
		JSON.parse(response, symbolize_names: true)
	end

	# initialize a member in the environment
	def self.member
		@member ||= Member.new
	end

	# class methods in the Member object access the environment
	# instance methods do the actual work
	def self.find(username)
		member.find(username)
	end

	class Member
		attr_accessor :attributes, :configuration, :username

		def initialize(attrs = {})
			@attributes = attrs
			@configuration
			@username
		end

		def self.find(username)
			@username = username
			Trello.find(username)
		end

		def find(username)
			url = "https://api.trello.com/1/members/#{username}?fields=all&#{credentials}"
			@attributes = Trello.parse(url)
			self
		end

		def configure
			return puts "No configuration details passed" unless block_given?
			yield configuration
			puts "Configuration worked!"
		end

		def configuration
			@configuration ||= Configuration.new
		end

		def credentials
			"key=#{@configuration.consumer_key}&token=#{@configuration.oauth_token}"
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

		def boards(number = "none")
			board_names = []
			attributes[:idBoards].each_with_index do |id_board, idx|
				number == "none" ? number = attributes[:idBoards].size : number
				board_number = idx + 1
				url = "https://api.trello.com/1/boards/#{id_board}?fields=all&#{credentials}"
				puts "Loading board #{board_number} of #{number} | Total is #{attributes[:idBoards].size}"
				board_names << Trello.parse(url)[:name]
				break if board_number == number
			end
			board_names
		end
	end
end