require 'rubygems'
require 'yahoo_weatherman'
require 'nokogiri'
require 'open-uri'

client = Weatherman::Client.new

puts "What's your location?"

userLocation = gets.chomp.gsub(" ", "%20").gsub(".","").gsub(",","").downcase

doc = Nokogiri::XML(open("http://where.yahooapis.com/v1/places.q('#{userLocation}')?appid=dj0yJmk9WEptYU5aN0JFNWphJmQ9WVdrOU9IZHBVRUl4TXpJbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmeD0yOA--"))

woeid = doc.css("woeid").inner_text

response = client.lookup_by_woeid woeid 

temperatureF = (((response.condition['temp'].to_i) * 1.8) + 32).round
conditionText = response.condition['text']

#other methods can be found here: https://github.com/dlt/yahoo_weatherman/blob/master/spec/yahoo_weatherman/response_spec.rb

puts "Current Conditions: \n#{conditionText}, #{temperatureF} F"
puts "Forecast: "

response.forecasts.each do |forecast|
	 puts forecast['day'].to_s + ' - Low: ' + (((forecast['low'].to_i)*1.8)+32).round.to_s + ' F; High: ' + (((forecast['high'].to_i)*1.8)+32).round.to_s + ' F; ' + forecast['text'].to_s 
end

#next step is to loop ovr hash that forecast creates and puts the values in a logicl order
