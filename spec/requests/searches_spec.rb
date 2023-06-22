require 'rails_helper'

RSpec.describe 'Searches', type: :request do
  describe 'GET /search' do
    context 'when zip_code param is missing' do
    end

    context 'when api service call fails' do
    end

    context 'when api service call is successful' do
      it 'displays the data' do
        data = {
          name: 'San Francisco',
          region: 'California',
          country: 'USA',
          current_weather: {
            temp_c: 10,
            temp_f: 60,
            condition: 'Foggy',
          },
          forecasted_weather: {
            max_temp_c: 20,
            max_temp_f: 70.0,
            min_temp_c: 5.5,
            min_temp_f: 49.9,
            condition: 'Really Foggy',
          }
        }
        res = double(success?: true, value!: data)
        expect_any_instance_of(FetchWeatherForecast).to receive(:call).and_return(res)

        get search_path, params: { zip_code: '123' }

        expect(response.status).to eq(200)
      end
    end
  end
end
