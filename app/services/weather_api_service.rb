require 'uri'
require 'net/http'

class WeatherApiService
  attr_reader :url

  def initialize
    @url = URI(ENV['WEATHER_API_URL'])
  end

  def http_get(params)
    url.query = URI.encode_www_form(params)

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["X-RapidAPI-Key"] = ENV['WEATHER_API_KEY']
    request["X-RapidAPI-Host"] = ENV['WEATHER_API_HOST']

    http.request(request)
  end
end
