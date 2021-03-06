require 'jumpstart_auth'
require 'bitly'
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
			  when 's' then spam_my_followers(parts[1..-1].join(" "))
			  when 'elt' then everyones_last_tweet
			  when 's' then shorten(parts[1])
			  when 'turl' then tweet(parts[1..-2].join(" ") + " " + shorten(parts[-1]))
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
	    puts screen_names
		puts "You can only dm those who follow you"
		end

	end

	def followers_list
		screen_names = []
		@client.followers.each  { |follower|screen_names << @client.user(follower).screen_name}
		
		return screen_names
	end

	def spam_my_followers(message)
		followers_list.each {|follower| dm(follower, "This is a test!")}
		end

	def everyones_last_tweet
    friends = @client.friends
    friends = friends.map { |friend| @client.user(friend) }
    friends.sort_by! { |friend| friend.screen_name.downcase}
   
    friends.each do |friend|
      timestamp = friend.status.created_at.strftime('%A, %b %d')
      tweet = friend.status.text
      puts "@#{friend.screen_name} said..."
      printf "#{tweet} at #{timestamp}"
      puts ''
    end
  end

  def shorten(original_url)
    bitly = Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6')
    puts "Shortening this url: #{original_url}"
    return bitly.shorten(original_url).short_url
    
   end
    

end
mytweet = "".ljust(140, "abcd")
blogger = MicroBlogger.new
blogger.run