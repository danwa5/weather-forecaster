require 'dry/monads'

class FetchWeatherForecast
  include Dry::Monads[:try]
  attr_reader :zip_code

  def initialize(zip_code)
    @zip_code = zip_code.to_s
  end

  def call
    Try do
      api = WeatherApiService.new
      res = api.http_get({ 'q' => zip_code })
      raise Errors::WeatherApiServiceError, "Error fetching weather forecast for #{zip_code} zip/postal code" unless res.code == '200'

      Api::WeatherForecastPresenter.new(res.body).as_json
    end
  end
end
