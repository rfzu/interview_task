class CalendarController < ApplicationController
  
  def index

    #get list of countries
    destinations = Typhoeus::Request.new(
    "https://level.travel/papi/references/countries",
    method: :get,
    headers: { Accept: "application/vnd.leveltravel.v2", Authorization: "Token token=f7bb8bac0a8893eb94b1b5f848e22876" }
    )

    destinations.run

    @dest ||= {}
    dest_json = JSON[destinations.response.body]
    dest_json.each_index do |i|
      @dest[dest_json[i]['iso2']] = dest_json[i]['name_ru']
    end

    #collect data for calendar
    @dest_country =   params[:dest_country]
    city          =   'Moscow'
    @date_start = Time.now.strftime("%Y.%m.%d")
    @date_end = (Time.now + (60*60*24*31)).strftime("%Y.%m.%d")

    request = Typhoeus::Request.new(
      "https://level.travel/papi/search/flights_and_nights?city_from=#{city}&country_to=#{@dest_country}&start_date=#{@date_start}&end_date=#{@date_end}&form=long",
      method: :get,
      headers: { Accept: "application/vnd.leveltravel.v2", Authorization: "Token token=f7bb8bac0a8893eb94b1b5f848e22876" }
    )

    request.run if @dest_country

    @cal ||= {}
    
    cal_json = JSON[request.response.body]['response'] if request.response
    @cal_json = cal_json

    cal_json.each_index do |i|
      @cal[cal_json[i]['date']] = cal_json[i]['nights']
    end if cal_json
    
    #collect data for mail
    @trip_date =   params[:trip_date]
    @days ||= params[:days].to_i
    @user_email =   params[:user_email]
    @letter ||= {}
    @letter_country ||= []

    @dest.each do |key, value|
      req4mail = Typhoeus::Request.new(
      "https://level.travel/papi/search/flights_and_nights?city_from=#{city}&country_to=#{key}&start_date=#{@trip_date}&end_date=#{@trip_date}&form=long",
      method: :get,
      headers: { Accept: "application/vnd.leveltravel.v2", Authorization: "Token token=f7bb8bac0a8893eb94b1b5f848e22876" }
      )
      req4mail.run if @trip_date
      @letter[value] = JSON[req4mail.response.body] if @trip_date
    end

    @letter.each do |key,value|
      @letter_country << key if value['response'][0]['nights'].include?(@days) 
    end
            
  end

end
