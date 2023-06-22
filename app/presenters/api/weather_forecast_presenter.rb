module Api
  class WeatherForecastPresenter
    attr_reader :json

    def initialize(forecast)
      @json = JSON.parse(forecast)
    end

    def as_json
      {
        name: location['name'],
        region: location['region'],
        country: location['country'],
        current_weather: {
          temp_c: current_weather['temp_c'],
          temp_f: current_weather['temp_f'],
          condition: current_weather['condition']['text'],
        },
        forecasted_weather: {
          max_temp_c: forecasted_weather_day['maxtemp_c'],
          max_temp_f: forecasted_weather_day['maxtemp_f'],
          min_temp_c: forecasted_weather_day['mintemp_c'],
          min_temp_f: forecasted_weather_day['mintemp_f'],
          condition: forecasted_weather_day['condition']['text'],
        }
      }
    end

    private

    def location
      @location ||= json['location']
    end

    def current_weather
      @current_weather ||= json['current']
    end

    def forecasted_weather_day
      @forecasted_weather_day ||= json['forecast']['forecastday'][0]['day']
    end
  end
end
