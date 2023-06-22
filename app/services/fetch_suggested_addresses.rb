require 'dry/monads'

class FetchSuggestedAddresses
  include Dry::Monads[:try]
  attr_reader :search_term

  def initialize(search_term)
    @search_term = search_term.to_s
  end

  def call
    Try do
      # make api call to Mapbox Api
      res = api.http_get({ 'q' => search_term })
      raise Errors::MapboxApiServiceError, "Error fetching address suggestions" unless res.code == '200'

      res.body
    end
  end

  private

  def api
    @api ||= MapboxApiService.new
  end
end
