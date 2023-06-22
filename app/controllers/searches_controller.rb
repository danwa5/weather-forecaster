
class SearchesController < ApplicationController
  # GET /search
  def show
    FetchWeatherForecast.new(zip_code).call
  end

  private

  def search_params
    params.permit(:zip_code)
  end

  def zip_code
    search_params['zip_code']
  end
end
