#! /usr/bin/ruby

require 'http'
require 'json'
require 'uri'
require 'dotenv'

Dotenv.load

round_length = 60

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


#create array of all players in the league in REVERSE order of finish last year
#players = Array['<@U1HNFUH9Q>', '<@U1HPYG9NW>', '<@U1HQF8L57>', '<@U1HNZTTJ6>', '<@U5G0HTRCP>', '<@U2R0113NW>', '<@U1HUPC3C0>', '<@U1HVAGFL6>', '<@U01G26SRHHC>', '<@U1J2WM3LL>'].shuffle
players = Array['Chris Greene', 'Joe Robert', 'Stuart Payment', 'Sam Stuckey', 'Zachary Jensen', 'Ryland Kagan', 'Greg Morelli', 'Jordan Nero', 'Spencer Scott', 'Charlie Russell', 'Alex Sarasohn', 'Nate Morelli'].shuffle
num_players = players.length

send_slack_message("*Welcome to the 2022 Nate Morelli Stupid League Draft Lottery*")

for l in 0..(num_players-1)
	if (l<num_players-3)
		message = "The " + (((num_players-1)-l)+1).to_s + "th pick goes to " + players[(num_players-1)-l]
	elsif (l == num_players-3)
		message =  "The 3rd pick goes to " + players[(num_players-1)-l]
	elsif (l == num_players-2)
		message =  "The 2nd pick goes to " + players[(num_players-1)-l]
	elsif (l == num_players-1)
		message = ":trophy: The first overall pick in the 2022 Nate Morelli Stupid League Draft will be " + players[(num_players-1)-l] + " :trophy:"
	end

	send_slack_message(message)

	sleep(round_length)
end

final_order = "*2022 Nate Morelli Stupid League Draft Order*\n"
final_order = final_order + ">1st: " + players[0] + "\n"
final_order = final_order + ">2nd: " + players[1] + "\n"
final_order = final_order + ">3rd: " + players[2] + "\n"
for i in 3..(num_players-1)
	final_order = final_order + ">" + (i+1).to_s + "th: " + players[i] + "\n"
end
final_order = final_order + ""

send_slack_message(final_order)
	


