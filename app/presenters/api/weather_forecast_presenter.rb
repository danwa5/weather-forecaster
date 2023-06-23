module Api
  # Serializes the required data from the raw data
  class WeatherForecastPresenter
    attr_reader :json

    def initialize(forecast)
      @json = JSON.parse(forecast)
    end

    # Parses the raw data and extracts the necessary attributes
    #
    # @return [Hash] the serialized data
    def as_json
      {
        name: location['name'],
        region: location['region'],
        country: location['country'],
        current_weather: current_weather_hash,
        forecasted_weather: forecasted_weather_hash
      }
    end

    private

    def current_weather_hash
      {
        temp_c: current_weather['temp_c'],
        temp_f: current_weather['temp_f'],
        condition: current_weather['condition']['text'],
        icon: format_icon_url(current_weather['condition']['icon'])
      }
    end

    def forecasted_weather_hash
      {
        max_temp_c: forecasted_weather_day['maxtemp_c'],
        max_temp_f: forecasted_weather_day['maxtemp_f'],
        min_temp_c: forecasted_weather_day['mintemp_c'],
        min_temp_f: forecasted_weather_day['mintemp_f'],
        condition: forecasted_weather_day['condition']['text'],
        icon: format_icon_url(forecasted_weather_day['condition']['icon'])
      }
    end

    def location
      @location ||= json['location']
    end

    def current_weather
      @current_weather ||= json['current']
    end

    def forecasted_weather_day
      @forecasted_weather_day ||= json['forecast']['forecastday'][0]['day']
    end

    def format_icon_url(path)
      return if path =~ /^https?/

      "https:#{path}"
    end
  end
end
