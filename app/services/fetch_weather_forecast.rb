require 'dry/monads'

class FetchWeatherForecast
  include Dry::Monads[:result, :do]
  include Dry::Monads[:try]
  attr_reader :zip_code

  def initialize(zip_code)
    @zip_code = zip_code.to_s
  end

  def call
    Try do
      # check if cached data exists for zip code
      cached_data = fetch_cached_results(zip_code)
      return Success(cached_data) unless cached_data.nil?

      # make api call to Weather Api
      res = api.http_get({ 'q' => zip_code })
      raise Errors::WeatherApiServiceError, "Error fetching weather forecast for #{zip_code} zip/postal code" unless res.code == '200'

      # serialize the required forecast data
      data = Api::WeatherForecastPresenter.new(res.body).as_json

      # cache data to limit calls to external API
      cache_results(data)

      data
    end
  end

  private

  def cache_results(data)
    Rails.cache.write(zip_code, data.merge(cached: true), expires_in: 30.minutes)
  end

  def fetch_cached_results(zip_code)
    Rails.cache.read(zip_code)
  end

  def api
    @api ||= WeatherApiService.new
  end
end
