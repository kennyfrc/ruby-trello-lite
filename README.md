# Ruby Trello Lite

This is a learning project using this gem: [ruby-trello](https://github.com/jeremytregunna/ruby-trello/blob/0e41660753cbbf1f68b005e408097a27019c6c8d/lib/trello/basic_data.rb#L45).

The idea behind this project is to replicate some features using the examples in the gem's documentation.

## How to use this project

1. Get your Trello API keys: [trello.com/api-key](https://trello.com/app-key/)
2. Clone the project to your local repository
3. In your repository, add `require './lib/trello'` in your "play" script. `run.rb` is provided as an example.
4. Run your script

## Features implemented so far:

1. Configuration

```
Trello.configure do |config|
  config.consumer_key = TRELLO_CONSUMER_KEY
  config.oauth_token = TRELLO_OAUTH_TOKEN
end
```

2. Member information

```
bob = Trello::Member.find("bobtester")

# Print out his name
puts bob.full_name # "Bob Tester"

# Print his bio
puts bob.bio # A wonderfully delightful test user
```

3. List member boards

```
# Print boards

puts bob.boards

# Optional: limit the number of boards to view

puts bob.boards(10)
```
## TODO:

* Add ability to do `bob.boards.first` and `bob.boards.first.list`
* Add ability to do `bob.boards("Board Name").list`


## Things I've Learned:

* How configuration through a block works (search for Trello.configure)
* How you can get standard libraries to work in local 
	(especially when autoload is used) ($LOAD_PATH.unshift 'lib'). This is true
	in the case where you use the original library
* Metaprogramming hacks
	* What I've noticed is that it's mainly a tool to add instance variables,
		methods, and classes after it has been defined. It reminds me of 
			the way you can set methods in javascript after an object has been defined.