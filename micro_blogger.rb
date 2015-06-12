require 'jumpstart_auth'

class MicroBlogger
	attr_reader :client

	def initialize
		puts "Initializing MicroBlogger"
		@client = JumpstartAuth.twitter
	end

	def tweet(message)
		if message.length <= 140 
			@client.update(message)
		else 
			puts "Tweets must be 140 Characters or less"
		end
	end
	def run
		command = ""
		puts "Welcome to the JSL Twitter Client!"
		while command != "q"
			printf "enter command: "
			input = gets.chomp
			parts = input.split(" ")
			command = parts[0]
			case command 
			  when 'q' then puts "Goodbye!"
			  when 't' then tweet(parts[1..-1].join(" "))
			  when 'dm' then dm(parts[1], parts[2..-1].join(" ")) 
			  else
			  	puts "Sorry, I don't know how to #{command}"
			  end
		end
	end

	def dm(target, message)
		screen_names = @client.followers.collect { |follower| @client.user(follower).screen_name }
		if screen_names.include?(target) 
		message = "d @#{target} #{message}"
		puts "Trying to send #{target} this direct message:"
		puts message
		tweet(message)
	    else
		puts "You can only dm those who follow you"
		end

	end

end
mytweet = "".ljust(140, "abcd")
blogger = MicroBlogger.new
blogger.run