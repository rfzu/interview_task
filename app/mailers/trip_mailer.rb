class TripMailer < ActionMailer::Base
  default from: "info@level.travel"

  def trip_letter(addr, countries, date, nights)
    @addr = addr
    @date = date
    @countries = countries
    @nights = nights 
    
    mail  to: @addr,
          subject: 'Result of your request'
  end

end
