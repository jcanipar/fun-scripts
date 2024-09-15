#! /usr/bin/ruby

require 'http'
require 'json'
require 'uri'
require 'dotenv'

Dotenv.load

def send_slack_message(message)
	channel = "fantasy-football"
	token = ENV['NERDS_OF_FEATHER_SLACK_TOKEN']
	rc = HTTP.post("https://slack.com/api/chat.postMessage", params: {
		token: token,
		channel: channel,
		text: message,
		as_user: true,
		username: "nerds_bot",
		parse: "none"
	})
end

time = Time.now

puts ENV['NERDS_OF_FEATHER_SLACK_TOKEN']

#create 55 "ping pong balls"
#78 for 12 players right?
balls = Array.new(78)


#create array of all players in the league in REVERSE order of finish last year
#players = Array['Holstein', 'Gage', 'Burt', 'Nasty Nate', 'Jason/Eric', 'Lenny', 'Jacob', 'Dan', 'Roman', 'Doug', 'Brad', 'Ben']
players = Array['Nathaniel \'Nasty Nate\' Smith', 'Nathan Morelli', 'Kyle Simpson', 'Luis Chunga-Celis', 'Jacob Caniparoli', 'Krishna Ramdeo', 'Shawn Basalyga', 'Adam Caniparoli', 'Aline Chunga Celis', 'Sean Burt', 'Zach Jensen', 'Dan Lanoue']

league_name = "Bad Boys in the Summer "
#league_name = "Notoriously Nasty FFL "
league_year = "2024"
time_to_sleep = 60


#print list of players
puts "Last year's finish"
puts players.to_s

previous_finish_msg = "*Last Year's Finish*\n"
previous_finish_msg = previous_finish_msg + ">1st: " + players[11] + "\n"
previous_finish_msg = previous_finish_msg + ">2nd: " + players[10] + "\n"
previous_finish_msg = previous_finish_msg + ">3rd: " + players[9] + "\n"
for i in 0..8
	previous_finish_msg = previous_finish_msg + ">" + (i+4).to_s + "th: " + players[8-i] + "\n"
end
previous_finish_msg = previous_finish_msg + ""

send_slack_message(previous_finish_msg)


h = Hash.new


for i in 0..11
	h[players[i] ] = 0
end

#current number of balls for team
weight = 12
current_ball = 0

#assign ping pong balls
for i in 0..players.size

	for j in 1..weight
		balls[current_ball] = players[i]
		current_ball = current_ball + 1
		#puts players[i]
	end

	weight = weight - 1
end


	#this array will store the draft order
	draft_order = Array.new(12)

	for i in 0..players.size-1
		continue = false
		begin
			selection = rand(78)
			player_selected = balls[selection]
		
			if !(draft_order.include? player_selected)
				continue = true

				draft_order[i] = player_selected

				output = player_selected + " was selected for the #{i+1} pick.  #{selection}"


				
			else
				#puts player_selected + " was selected but already has a pick.  #{selection}"
			end

		end until continue	
	end

	for l in 0..11
		h[draft_order[l]]=h[draft_order[l]] + (l+1)

	end

	send_slack_message("*" + league_name + " Draft Lottery*")


	for l in 0..11
		sleep(time_to_sleep)

		if (l<9)
			message = "The " + ((11-l)+1).to_s + "th pick goes to " + draft_order[11-l]
		elsif (l == 9)
			message =  "The 3rd pick goes to " + draft_order[11-l]
		elsif (l == 10)
			message =  "The 2nd pick goes to " + draft_order[11-l]
		elsif (l == 11)
			message = ":trophy: The first overall pick in the " + league_year + " " + league_name + " Draft will be " + draft_order[11-l] + " :trophy:"
		end

		send_slack_message(message)

		
	end

	sleep(time_to_sleep/2)

	previous_finish_msg = "*" + league_year + " " + league_name + " " + "Official Draft Order*\n"
	previous_finish_msg = previous_finish_msg + ">1st: " + draft_order[0] + "\n"
	previous_finish_msg = previous_finish_msg + ">2nd: " + draft_order[1] + "\n"
	previous_finish_msg = previous_finish_msg + ">3rd: " + draft_order[2] + "\n"
	for i in 3..11
		previous_finish_msg = previous_finish_msg + ">" + (i+1).to_s + "th: " + draft_order[i] + "\n"
	end
	previous_finish_msg = previous_finish_msg + ""

	send_slack_message(previous_finish_msg)

