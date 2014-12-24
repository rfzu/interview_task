require 'typhoeus'
require 'json'

puts "hi!"
=begin
p Typhoeus.get("https://level.travel")

puts "========================="

p request = Typhoeus::Request.new(
  "https://level.travel",
  method: :get,
  headers: { Accept: "application/vnd.leveltravel.v2", Authorization: "token=\"f7bb8bac0a8893eb94b1b5f848e22876\"" }
)

puts "========================="

p request.run

puts "========================="
=end

#p Typhoeus.get("https://level.travel/papi/search/flights_and_nights?city_from=Moscow&country_to=EG&start_date=01.02.2013&end_date=30.06.2013", headers: {"Accept" => "application/vnd.leveltravel.v2", "Authorization" => "Token token=f7bb8bac0a8893eb94b1b5f848e22876"})

city      = 'Moscow'
country   = 'DO' #DO, EG, TU, DO, TH

request = Typhoeus::Request.new(
  "https://level.travel/papi/search/flights_and_nights?city_from=#{city}&country_to=#{country}&start_date=25.12.2014&end_date=03.01.2015&form=long",
  method: :get,
  headers: { Accept: "application/vnd.leveltravel.v2", Authorization: "Token token=f7bb8bac0a8893eb94b1b5f848e22876" }
)

request.run
#puts JSON[request.response.body]['response'].class

destinations = Typhoeus::Request.new(
  "https://level.travel/papi/references/destinations",
  method: :get,
  headers: { Accept: "application/vnd.leveltravel.v2", Authorization: "Token token=f7bb8bac0a8893eb94b1b5f848e22876" }
)

destinations.run
dest ||= {}
dest2 = JSON[destinations.response.body
dest2.each_index do |i|
  p dest2[i] if dest2[i]['name_ru'] == 'Россия'
  #dest[dest2[i]['iso2']] = dest2[i]['name_ru']
end
#p dest