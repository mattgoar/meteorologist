require 'open-uri'
require 'json'

class MeteorologistController < ApplicationController
    def street_to_weather_form
        # Nothing to do here.
        render("street_to_weather_form.html.erb")
    end

    def street_to_weather
        @street_address = params[:user_street_address]


        # Generic Code for API Loading
        #
        # Check for empty user inputs

        if @street_address.blank?
            render :file => 'public/500.html', :status => 500, :layout => false
        else

            #
            # Encode user inputs to remove invalid URL characters
            #

            url_safe_street_address = URI.encode(@street_address)

            url_geo = open('https://maps.googleapis.com/maps/api/geocode/json?address='+url_safe_street_address)
            raw_geo_data = url_geo.read

            parsed_geo_data = JSON.parse(raw_geo_data)

            lat = parsed_geo_data["results"][0]["geometry"]["location"]["lat"]
            lng = parsed_geo_data["results"][0]["geometry"]["location"]["lng"]

            if lat.blank? || lng.blank?
                render :file => 'public/500.html', :status => 500, :layout => false
            else

                url_safe_lat = lat.to_s
                url_safe_lng = lng.to_s

                #
                # Get JSON Hash
                # Only update api_url & api_arg

                api_url = 'https://api.forecast.io/forecast/d4bbf5ef52d70f1b64cfc5bd80bbf0d7/'
                api_arg = url_safe_lat + ',' + url_safe_lng

                # Next three lines are universal
                url_wthr = open(api_url + api_arg)
                raw_wthr_data = url_wthr.read
                parsed_wthr_data = JSON.parse(raw_wthr_data)


                @current_temperature = parsed_wthr_data["currently"]["temperature"]

                @current_summary = parsed_wthr_data["currently"]["summary"]

                @summary_of_next_sixty_minutes = parsed_wthr_data["minutely"]["summary"]

                @summary_of_next_several_hours = parsed_wthr_data["hourly"]["summary"]

                @summary_of_next_several_days = parsed_wthr_data["daily"]["summary"]

                render("street_to_weather.html.erb")
            end
        end
    end
end
