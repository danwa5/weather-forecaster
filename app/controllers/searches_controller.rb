
class SearchesController < ApplicationController
  # GET /search
  def show
    if zip_code
      res = FetchWeatherForecast.new(zip_code).call

      if res.success?
        @results = res.value!
      else
        redirect_to search_path, flash: { error: res.exception }
      end
    end
  end

  private

  def search_params
    params.permit(:zip_code)
  end

  def zip_code
    search_params['zip_code']
  end
end
