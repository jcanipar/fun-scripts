require 'JSON'
require 'net/http'
require 'csv'
require 'dotenv'

Dotenv.load

url = 'http://api.sportradar.us/nfl/official/trial/v5/en/seasons/2018/standings.json?api_key=' + ENV['SPORTSRADAR_API_KEY']
uri = URI(url)

response = Net::HTTP.get(uri)
obj = JSON.parse(response)

standings = Array.new

conferences = obj["conferences"]

conferences.each do | conference |
	conference["divisions"].each do | division |
		division["teams"].each do | team |
			ary_team = [team["market"] + " " + team["name"], team["wins"]]
			standings << ary_team
			puts team["name"] + " - " + team["wins"].to_s
		end
	end
end

puts standings[3][0] + " " + standings[3][1].to_s

# ary_team.each do | team |
# 	text = 
# end

#File.open(yourfile, 'w') { |file| file.write("your text") }

CSV.open("file.csv", "wb") do | csv |

	standings.sort!.each do | team |
		csv << [team[0], team[1]]
	end

end
 
