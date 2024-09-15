#! /usr/bin/ruby

require 'http'
require 'json'
require 'uri'
require 'dotenv'

Dotenv.load

def send_slack_message(message)
	channel = "fantasy-basketball"
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

#morelli - U1HNZTTJ6
#nasty - U1HPYG9NW
#alex - U1J2WM3LL
#chunga - U1HQF8L57
#burt - U1HVAGFL6
#jacob - U1HNFUH9Q
#ayron - U2R0113NW
#greg - U5G0HTRCP
#nats - U8C493U58


#create array of all players in the league in order of finish last year
#players = Array['<@U1HNZTTJ6>', '<@U1HQF8L57>', 'Adam', 'Krishna', '<@U1HNFUH9Q>', 'Dan', '<@U2R0113NW>', '<@U1HPYG9NW>', '<@U8C493U58>', '<@U1HVAGFL6>' ]
players = Array['Krishna', '<@U5G0HTRCP>', '<@U8C493U58>', '<@U1HNFUH9Q>', '<@U2R0113NW>', '<@U1HPYG9NW>', 'Dan', 'Adam', '<@U1HNZTTJ6>', '<@U1HQF8L57>' ].reverse

num_players = players.size

pongballs = 0
for i in (1..num_players).to_a.reverse
	pongballs = pongballs + i
end
puts "Pingpong balls: " + pongballs.to_s

#create 55 "ping pong balls"
#78 for 12 players right?

balls = Array.new(pongballs)


#print list of players
puts "Last year's finish"
puts players.to_s

previous_finish_msg = "*Last Year's Finish*\n"
previous_finish_msg = previous_finish_msg + ">1st: " + players[0] + "\n"
previous_finish_msg = previous_finish_msg + ">2nd: " + players[1] + "\n"
previous_finish_msg = previous_finish_msg + ">3rd: " + players[2] + "\n"
for i in 3..num_players-1
	previous_finish_msg = previous_finish_msg + ">" + (i+1).to_s + "th: " + players[i] + "\n"
end
previous_finish_msg = previous_finish_msg + ""

send_slack_message(previous_finish_msg)

#flips the weighting so that sucky bad players get a better chance to win
players = players.reverse
puts players.to_s

h = Hash.new


for i in 0..(num_players-1)
	h[players[i] ] = 0
end

#current number of balls for team
weight = num_players
current_ball = 0

#assign ping pong balls
for i in 0..players.size

	for j in 1..weight
		balls[current_ball] = players[i]
			current_ball = current_ball + 1
	end

	weight = weight - 1
end


	#this array will store the draft order
	draft_order = Array.new(num_players)

	for i in 0..players.size-1
		continue = false
		begin
			selection = rand(pongballs)
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

	for l in 0..(num_players-1)
		h[draft_order[l]]=h[draft_order[l]] + (l+1)

	end

	#send_slack_message("*The 2021 Fantasy Basketball Draft Summary*")


	for l in 0..(num_players-1)
		if (l<(num_players-3))
			message = "The " + (((num_players-1)-l)+1).to_s + "th pick goes to " + draft_order[(num_players-1)-l]
		elsif (l == (num_players-3))
			message =  "The 3rd pick goes to " + draft_order[(num_players-1)-l]
		elsif (l == (num_players-2))
			message =  "The 2nd pick goes to " + draft_order[(num_players-1)-l]
		elsif (l == (num_players-1))
			message = ":trophy: The first overall pick in the 2023 Fantasy NBA Draft will be " + draft_order[(num_players-1)-l] + " :trophy:"
		end

		send_slack_message(message)

		sleep(60)
	end

	sleep(1)

	previous_finish_msg = "*2023 Official Draft Order*\n"
	previous_finish_msg = previous_finish_msg + ">1st: " + draft_order[0] + "\n"
	previous_finish_msg = previous_finish_msg + ">2nd: " + draft_order[1] + "\n"
	previous_finish_msg = previous_finish_msg + ">3rd: " + draft_order[2] + "\n"
	for i in 3..(num_players-1)
		previous_finish_msg = previous_finish_msg + ">" + (i+1).to_s + "th: " + draft_order[i] + "\n"
	end
	previous_finish_msg = previous_finish_msg + ""

	send_slack_message(previous_finish_msg)

