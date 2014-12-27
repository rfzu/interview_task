class CountryMailWorker
  include Sidekiq::Worker

  def perform(email, date, days, dest, city='Moscow')
    letter ||= {}
    letter_country ||= []

    dest.each do |key, value|
      req4mail = Typhoeus::Request.new(
      "https://level.travel/papi/search/flights_and_nights?city_from=#{city}&country_to=#{key}&start_date=#{date}&end_date=#{date}&form=long",
      method: :get,
      headers: { Accept: "application/vnd.leveltravel.v2", Authorization: "Token token=f7bb8bac0a8893eb94b1b5f848e22876" }
      )
      req4mail.run if date
      letter[value] = JSON[req4mail.response.body] if date
    end

    letter.each do |key,value|
      letter_country << key if value['response'][0]['nights'].include?(days) 
    end

    TripMailer.trip_letter(email, letter_country, date, days).deliver if letter_country.any?
    puts "mail delivered to #{email}"
  end
end