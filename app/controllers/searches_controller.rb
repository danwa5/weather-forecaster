
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

  # GET /search/autocomplete?search_term=<ADDRESS>
  def autocomplete
    res = FetchSuggestedAddresses.new(search_term).call
    data = res.success? ? res.value! : {}
    render json: data
  end

  private

  def search_params
    params.permit(:search_term)
  end

  def search_term
    search_params['search_term']
  end

  def zip_code
    search_term.split(',').last
  rescue
    nil
  end
end
