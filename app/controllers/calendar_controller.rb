class CalendarController < ApplicationController
  
  def index

    @dest = destination_list
    @dest_country =   params[:dest_country]
    @date_start = Time.now.strftime("%Y-%m-%d")
    @date_end = (Time.now + (60*60*24*37)).strftime("%Y-%m-%d")
    @city          =   'Moscow'
    @cal = calendar_data if @dest_country
    @trip_date =   params[:trip_date]
    @days = params[:days].to_i
    @user_email =   params[:user_email]

    CountryMailWorker.perform_async(@user_email, @trip_date, @days, @dest) if @user_email

  end

  def destination_list
    destinations = Typhoeus::Request.new(
    "https://level.travel/papi/references/countries",
    method: :get,
    headers: { Accept: "application/vnd.leveltravel.v2", Authorization: "Token token=f7bb8bac0a8893eb94b1b5f848e22876" }
    )

    destinations.run

    dest ||= {}
    dest_json = JSON[destinations.response.body]
    dest_json.each_index do |i|
      dest[dest_json[i]['iso2']] = dest_json[i]['name_ru']
    end
    dest
  end

  def calendar_data

    request = Typhoeus::Request.new(
      "https://level.travel/papi/search/flights_and_nights?city_from=#{@city}&country_to=#{@dest_country}&start_date=#{@date_start}&end_date=#{@date_end}&form=long",
      method: :get,
      headers: { Accept: "application/vnd.leveltravel.v2", Authorization: "Token token=f7bb8bac0a8893eb94b1b5f848e22876" }
    )

    request.run

    cal ||= {}    
    cal_json = JSON[request.response.body]['response'] if request.response
    
    cal_json.each_index do |i|
      cal[cal_json[i]['date']] = cal_json[i]['nights']
    end if cal_json
    cal
  end

end