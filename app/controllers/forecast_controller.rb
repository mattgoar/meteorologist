require 'open-uri'

class ForecastController < ApplicationController
  def coords_to_weather_form
    # Nothing to do here.
    render("coords_to_weather_form.html.erb")
  end

  def coords_to_weather
    @lat = params[:user_latitude]
    @lng = params[:user_longitude]

    # ==========================================================================
    # Your code goes below.
    # The latitude the user input is in the string @lat.
    # The longitude the user input is in the string @lng.
    # ==========================================================================

      # Generic Code for API Loading
      #
      # Check for empty user inputs

    if @lat.blank? || @lng.blank?
      render :file => 'public/500.html', :status => 500, :layout => false
    else

      #
      # Encode user inputs to remove invalid URL characters
      #

      url_safe_lat = URI.encode(@lat)
      url_safe_lng = URI.encode(@lng)

      #
      # Get JSON Hash
      # Only update api_url & api_arg

      api_url = 'https://api.forecast.io/forecast/d4bbf5ef52d70f1b64cfc5bd80bbf0d7/'
      api_arg = url_safe_lat + ',' + url_safe_lng

      # Next three lines are universal
      url = open(api_url + api_arg)
      raw_data = url.read
      parsed_data = JSON.parse(raw_data)

      @current_temperature = parsed_data["currently"]["temperature"]

      @current_summary = parsed_data["currently"]["summary"]

      @summary_of_next_sixty_minutes = parsed_data["minutely"]["summary"]

      @summary_of_next_several_hours = parsed_data["hourly"]["summary"]

      @summary_of_next_several_days = parsed_data["daily"]["summary"]

      render("coords_to_weather.html.erb")
    end
  end
end
